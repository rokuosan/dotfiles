package Dotfiles::Process;

use v5.40;
use Exporter qw(import);

our @EXPORT_OK = qw(run_command capture require_commands);

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
    waitpid( $pid, 0 ) == $pid or die "waitpid: $!\n";
    my $status = $?;
    die "$command[0] terminated by signal " . ( $status & 127 ) . "\n" if $status & 127;
    die "$command[0] exited with status " .   ( $status >> 8 ) . "\n"  if $status;
    return;
}

sub capture {
    my (@command) = @_;
    open my $pipe, '-|', @command or die "$command[0]: $!\n";
    local $/ = undef;
    my $text = <$pipe> // '';
    close $pipe or die "$command[0] failed (status $?)\n";
    return $text;
}

sub require_commands {
    my (@commands) = @_;
    for my $command (@commands) {
        die "$command is not installed or not in PATH\n" unless grep {
            my $path = "$_/$command";
            -f $path && -x $path;
        } split /:/, ( $ENV{PATH} // '' );
    }
    return;
}

1;

=head1 NAME

Dotfiles::Process - Process helpers for utility tasks

=head1 SYNOPSIS

    use Dotfiles::Process qw(run_command capture require_commands);

    require_commands('git');
    run_command(undef, 'status.txt', 'git', 'status');
    my $output = capture('git', 'status', '--porcelain');

=head1 FUNCTIONS

=head2 run_command($input, $output, @command)

Run a command without a shell and fail on a nonzero exit status or signal.
Input and output paths redirect stdin and stdout; undef inherits the parent's
stream. Stderr is inherited.

=head2 capture(@command)

Return stdout unchanged, including trailing newlines. Stderr is inherited.
Fail if the command cannot start or exits unsuccessfully.

=head2 require_commands(@commands)

Fail if any command is not an executable file on PATH.

=cut
