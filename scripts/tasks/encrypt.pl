#!/usr/bin/env perl
#MISE alias="encrypt"
#MISE description="Encrypt data with the SSH key stored in 1Password using age."
#MISE tools={perl="latest"}
#MISE dir="{{cwd}}"
#MISE raw=true
use v5.40;
use Getopt::Long qw(GetOptionsFromArray);
use File::Temp   qw(tempdir);
use Fcntl        qw(O_WRONLY O_CREAT O_EXCL);
use File::Copy   qw(copy);

use FindBin qw($RealBin);
use lib "$RealBin/lib";
use Dotfiles::Process qw(run_command capture require_commands);

exit main(@ARGV);

sub main {
    my @arguments = @_;
    my $key_ref   = $ENV{OP_SSH_SIGN_KEY_REF} || 'op://token/id_ed25519/private key';
    my ( $input, $output, $help );
    $key_ref = $ENV{OP_SSH_ENCRYPT_KEY_REF} || $key_ref;
    my ( $decrypt, $armor );
    Getopt::Long::Configure( 'no_auto_abbrev', 'no_ignore_case', 'permute' );
    GetOptionsFromArray(
        \@arguments,
        'ref|r=s'    => \$key_ref,
        'output|o=s' => \$output,
        'decrypt|d'  => \$decrypt,
        'armor|a'    => \$armor,
        'help|h'     => \$help,
    ) or return 2;
    if ($help) {
        usage();
        return 0;
    }
    die "encrypt: only one input file is supported\n" if @arguments > 1;
    $input = shift @arguments;
    die "encrypt: input file is not readable: $input\n" if defined $input && !-r $input;
    die "encrypt: key reference must not be empty\n" unless length $key_ref;
    die "encrypt: input must be a regular file\n"          if defined $input  && !-f $input;
    die "encrypt: --armor cannot be used with --decrypt\n" if $decrypt        && $armor;
    die "encrypt: output must not be empty\n"              if defined $output && !length $output;
    $output //= !$decrypt && defined $input ? "$input.age" : '-';
    die "encrypt: output already exists: $output\n"
        if $output ne '-' && ( -e $output || -l $output );

    require_commands(qw(op ssh-keygen age));

    umask 0077;
    my $tmpdir = tempdir( 'op-ssh-encrypt-XXXXXXXXXX', TMPDIR => 1, CLEANUP => 1 );
    local $SIG{INT}  = sub { exit 130 };
    local $SIG{HUP}  = sub { exit 143 };
    local $SIG{TERM} = sub { exit 143 };
    my $key_file = "$tmpdir/key";
    run_command( undef, '/dev/null', 'op', 'read', '--force', '--out-file', $key_file, $key_ref );
    chmod 0600, $key_file or die "chmod $key_file: $!\n";

    my @age_args;
    if ($decrypt) {
        @age_args = ( '--decrypt', '--identity', $key_file );
    }
    else {
        my $recipient = capture( 'ssh-keygen', '-y', '-P', '', '-f', $key_file );
        chomp $recipient;
        die "encrypt: only Ed25519 and RSA SSH keys are supported\n"
            unless $recipient =~ /\Assh-(?:ed25519|rsa) /;
        @age_args = ( '--encrypt', '--recipient', $recipient );
        push @age_args, '--armor' if $armor;
    }

    # Stage output so failed encryption or authentication never publishes partial data.
    run_command( $input, "$tmpdir/result", 'age', @age_args );
    if ( $output eq '-' ) {
        copy( "$tmpdir/result", \*STDOUT ) or die "stdout: $!\n";
    }
    else {
        sysopen my $dest, $output, O_WRONLY | O_CREAT | O_EXCL, 0600 or die "$output: $!\n";
        copy( "$tmpdir/result", $dest ) or die "$output: $!\n";
        close $dest                     or die "$output: $!\n";
    }
    return 0;
}

sub usage {
    print <<'USAGE';
Usage:
  encrypt [options] [file]

Encrypt data with the SSH key stored in 1Password using age.

Options:
  -r, --ref OP_REFERENCE     Override the 1Password secret reference
  -o, --output FILE          Write to FILE (must not already exist)
  -a, --armor                Output ASCII-armored ciphertext
  -d, --decrypt              Decrypt using the same 1Password private key
  -h, --help                 Show this help

With a file, encryption defaults to file.age. Otherwise, read stdin and write
stdout. Decryption writes stdout unless --output is specified. Use -o - to
explicitly write stdout. Options may appear before or after the input file.

Key reference: OP_SSH_ENCRYPT_KEY_REF, then OP_SSH_SIGN_KEY_REF, then
op://token/id_ed25519/private key. Supports Ed25519 and RSA SSH keys.
Requires: op, ssh-keygen, age (brew install age).
USAGE
    return;
}
