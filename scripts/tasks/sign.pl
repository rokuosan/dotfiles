#!/usr/bin/env perl
#MISE alias="sign"
#MISE description="Sign arbitrary data with an OpenSSH private key stored in 1Password."
#MISE tools={perl="latest"}
#MISE dir="{{cwd}}"
#MISE raw=true
use v5.40;
use Getopt::Long qw(GetOptionsFromArray);
use File::Temp   qw(tempdir);

use FindBin qw($RealBin);
use lib "$RealBin/lib";
use Dotfiles::Process qw(run_command require_commands);

exit main(@ARGV);

sub main {
    my @arguments = @_;
    my $key_ref   = $ENV{OP_SSH_SIGN_KEY_REF} || 'op://token/id_ed25519/private key';
    my ( $input, $output, $help );
    my $namespace = $ENV{OP_SSH_SIGN_NAMESPACE} || 'file';
    my $hashalg   = 'sha512';
    Getopt::Long::Configure( 'no_auto_abbrev', 'no_ignore_case', 'require_order' );
    GetOptionsFromArray(
        \@arguments,
        'ref|r=s'       => \$key_ref,
        'namespace|n=s' => \$namespace,
        'output|o=s'    => \$output,
        'hashalg=s'     => \$hashalg,
        'help|h'        => \$help,
    ) or return 2;
    if ($help) {
        usage();
        return 0;
    }
    die "sign: only one input file is supported\n" if @arguments > 1;
    $input = shift @arguments;
    die "sign: input file is not readable: $input\n" if defined $input && !-r $input;
    die "sign: key reference must not be empty\n" unless length $key_ref;
    die "namespace must not be empty\n"           unless length $namespace;
    die "--hashalg must be sha256 or sha512\n"    unless $hashalg =~ /\A(?:sha256|sha512)\z/;

    require_commands(qw(op ssh-keygen));

    umask 0077;
    my $tmpdir = tempdir( 'op-ssh-sign-XXXXXXXXXX', TMPDIR => 1, CLEANUP => 1 );
    local $SIG{INT}  = sub { exit 130 };
    local $SIG{HUP}  = sub { exit 143 };
    local $SIG{TERM} = sub { exit 143 };
    my $key_file = "$tmpdir/key";
    run_command( undef, '/dev/null', 'op', 'read', '--force', '--out-file', $key_file, $key_ref );
    chmod 0600, $key_file or die "chmod $key_file: $!\n";

    my @args = ( '-q', '-Y', 'sign', '-f', $key_file, '-n', $namespace, '-O', "hashalg=$hashalg" );
    if ( defined $output && length $output ) {
        run_command( $input, $output, 'ssh-keygen', @args );
    }
    elsif ( defined $input ) {
        run_command( undef, undef, 'ssh-keygen', @args, $input );
    }
    else {
        run_command( undef, undef, 'ssh-keygen', @args );
    }
    return 0;
}

sub usage {
    print <<'USAGE';
Usage:
  sign [options] [file]

Sign arbitrary data with an OpenSSH private key stored in 1Password.

Options:
  -r, --ref OP_REFERENCE     Override the 1Password secret reference
  -n, --namespace NAME       SSH signature namespace (default: file)
  -o, --output FILE          Write signature to FILE
  --hashalg sha256|sha512    Hash algorithm passed to ssh-keygen (default: sha512)
  -h, --help                 Show this help

If file is omitted, data is read from stdin and the signature is written to
stdout unless --output is specified.

When file is specified without --output, ssh-keygen writes file.sig.
USAGE
    return;
}
