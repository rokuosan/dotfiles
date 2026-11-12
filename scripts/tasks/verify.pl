#!/usr/bin/env perl
#MISE alias="verify"
#MISE description="Verify data against an SSH signature using the OpenSSH key stored in 1Password."
#MISE tools={perl="latest"}
#MISE dir="{{cwd}}"
#MISE raw=true
use v5.40;
use Getopt::Long qw(GetOptionsFromArray);
use File::Temp   qw(tempdir);

use FindBin qw($RealBin);
use lib "$RealBin/lib";
use Dotfiles::Process qw(run_command capture require_commands);

exit main(@ARGV);

sub main {
    my @arguments = @_;
    my $key_ref   = $ENV{OP_SSH_SIGN_KEY_REF} || 'op://token/id_ed25519/private key';
    my ( $input, $output, $help );
    my $namespace = $ENV{OP_SSH_SIGN_NAMESPACE} || 'file';
    my $identity  = $ENV{OP_SSH_SIGN_IDENTITY}  || 'signer';
    my $signature;
    Getopt::Long::Configure( 'no_auto_abbrev', 'no_ignore_case', 'require_order' );
    GetOptionsFromArray(
        \@arguments,
        'ref|r=s'       => \$key_ref,
        'namespace|n=s' => \$namespace,
        'identity|I=s'  => \$identity,
        'signature|s=s' => \$signature,
        'help|h'        => \$help,
    ) or return 2;

    if ($help) {
        usage();
        return 0;
    }
    die "verify: only one input file is supported\n" if @arguments > 1;
    $input = shift @arguments;
    die "verify: input file is not readable: $input\n" if defined $input && !-r $input;
    die "verify: key reference must not be empty\n" unless length $key_ref;
    die "namespace must not be empty\n"             unless length $namespace;
    die "verify: set --signature\n"                 unless defined $signature && length $signature;
    die "verify: signature file is not readable: $signature\n" unless -r $signature;
    die "verify: identity must not be empty\n"                 unless length $identity;

    require_commands(qw(op ssh-keygen));

    umask 0077;
    my $tmpdir = tempdir( 'op-ssh-verify-XXXXXXXXXX', TMPDIR => 1, CLEANUP => 1 );
    local $SIG{INT}  = sub { exit 130 };
    local $SIG{HUP}  = sub { exit 143 };
    local $SIG{TERM} = sub { exit 143 };
    my $key_file = "$tmpdir/key";
    run_command( undef, '/dev/null', 'op', 'read', '--force', '--out-file', $key_file, $key_ref );
    chmod 0600, $key_file or die "chmod $key_file: $!\n";

    my $public_key = capture( 'ssh-keygen', '-y', '-f', $key_file );
    chomp $public_key;
    my $allowed_signers = "$tmpdir/allowed_signers";
    open my $allowed, '>', $allowed_signers or die "$allowed_signers: $!\n";
    print {$allowed} "$identity $public_key\n";
    close $allowed or die "$allowed_signers: $!\n";
    run_command(
        $input,           undef, 'ssh-keygen', '-Y', 'verify',   '-f',
        $allowed_signers, '-I',  $identity,    '-n', $namespace, '-s',
        $signature
    );
    return 0;
}

sub usage {
    print <<'USAGE';
Usage:
  verify -s SIGNATURE [options] [file]

Verify data against an SSH signature using the OpenSSH key stored in 1Password.

Options:
  -s, --signature FILE       SSH signature file
  -r, --ref OP_REFERENCE     Override the 1Password secret reference
  -n, --namespace NAME       SSH signature namespace (default: file)
  -I, --identity NAME        Signer identity used for allowed signers (default: signer)
  -h, --help                 Show this help

If file is omitted, data is read from stdin.
USAGE
    return;
}
