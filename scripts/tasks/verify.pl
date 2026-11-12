#!/usr/bin/env perl
#MISE alias="verify"
#MISE description="Verify data against an SSH signature using the OpenSSH key stored in 1Password."
#MISE tools={perl="latest"}
#MISE dir="{{cwd}}"
#MISE raw=true
use v5.40;
use Getopt::Long qw(GetOptions);
use File::Temp   qw(tempdir);

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
}

my $key_ref = $ENV{OP_SSH_SIGN_KEY_REF} || 'op://token/id_ed25519/private key';
my ( $input, $output, $help );
my $namespace = $ENV{OP_SSH_SIGN_NAMESPACE} || 'file';
my $identity  = $ENV{OP_SSH_SIGN_IDENTITY}  || 'signer';
my $signature;
Getopt::Long::Configure( 'no_auto_abbrev', 'no_ignore_case', 'require_order' );
GetOptions(
    'ref|r=s'       => \$key_ref,
    'namespace|n=s' => \$namespace,
    'identity|I=s'  => \$identity,
    'signature|s=s' => \$signature,
    'help|h'        => \$help,
) or exit 2;

if ($help) {
    usage();
    exit 0;
}
die "verify: only one input file is supported\n" if @ARGV > 1;
$input = shift @ARGV;
die "verify: input file is not readable: $input\n" if defined $input && !-r $input;
die "verify: key reference must not be empty\n" unless length $key_ref;
die "namespace must not be empty\n"             unless length $namespace;
die "verify: set --signature\n"                 unless defined $signature && length $signature;
die "verify: signature file is not readable: $signature\n" unless -r $signature;
die "verify: identity must not be empty\n"                 unless length $identity;

for my $dependency ( 'op', 'ssh-keygen' ) {
    die "verify: $dependency is not installed or not in PATH\n" unless grep {
        my $path = "$_/$dependency";
        -f $path && -x $path;
    } split /:/, ( $ENV{PATH} // '' );
}

umask 0077;
my $tmpdir = tempdir( 'op-ssh-verify-XXXXXXXXXX', TMPDIR => 1, CLEANUP => 1 );
$SIG{INT} = sub { exit 130 };
$SIG{HUP} = $SIG{TERM} = sub { exit 143 };
my $key_file = "$tmpdir/key";
run_command( undef, '/dev/null', 'op', 'read', '--force', '--out-file', $key_file, $key_ref );
chmod 0600, $key_file or die "chmod $key_file: $!\n";

my $public_key      = capture( 'ssh-keygen', '-y', '-f', $key_file );
my $allowed_signers = "$tmpdir/allowed_signers";
open my $allowed, '>', $allowed_signers or die "$allowed_signers: $!\n";
print {$allowed} "$identity $public_key\n";
close $allowed or die "$allowed_signers: $!\n";
run_command(
    $input,           undef, 'ssh-keygen', '-Y', 'verify',   '-f',
    $allowed_signers, '-I',  $identity,    '-n', $namespace, '-s',
    $signature
);

sub run_command {
    my ( $input, $output, @command ) = @_;
    my $pid = fork // die "fork: $!\n";
    if ( !$pid ) {
        if ( defined $input ) {
            open STDIN, '<', $input or die "$input: $!\n";
        }
        if ( defined $output ) {
            open STDOUT, '>', $output or die "$output: $!\n";
        }
        exec { $command[0] } @command;
        die "exec $command[0]: $!\n";
    }
    waitpid( $pid, 0 );
    my $status = $?;
    die "$command[0] terminated by signal " . ( $status & 127 ) . "\n" if $status & 127;
    die "$command[0] exited with status " .   ( $status >> 8 ) . "\n"  if $status;
}

sub capture {
    my (@command) = @_;
    open my $pipe, '-|', @command or die "$command[0]: $!\n";
    local $/;
    my $text = <$pipe> // '';
    close $pipe or die "$command[0] failed (status $?)\n";
    $text =~ s/\n+\z//;
    return $text;
}
