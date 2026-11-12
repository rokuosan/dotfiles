#!/usr/bin/env perl
#MISE alias="brewup"
#MISE description="Update Homebrew and installed packages"
#MISE tools={perl="latest"}
#MISE dir="{{cwd}}"
#MISE raw=true
use strict;
use warnings;
use utf8;
use POSIX qw(strftime);

use Getopt::Long qw(GetOptionsFromArray);
use Pod::Usage   qw(pod2usage);

=head1 NAME

brewup - Update Homebrew and all installed packages

=head1 SYNOPSIS

    brewup [--dry-run|-n] [--help|-h]

=head1 OPTIONS

=over 4

=item B<--dry-run>, B<-n>

Only print commands without executing.

=item B<--help>, B<-h>

Show this help message.

=back

=head1 DESCRIPTION

This script updates Homebrew and all installed packages. It checks if Homebrew is installed, and if not, it provides instructions on how to install it. Then it runs the following commands in sequence:
- brew update
- brew upgrade
- brew autoremove
- brew cleanup
Each command is executed with error handling, and the script prints timestamps and command information in color if the output is a terminal.

=cut

exit main(@ARGV);

sub main {
    my @arguments = @_;
    my ( $dry_run, $help );
    Getopt::Long::Configure( 'no_auto_abbrev', 'no_ignore_case' );
    GetOptionsFromArray(
        \@arguments,
        'dry-run|n' => \$dry_run,
        'help|h'    => \$help,
    ) or pod2usage(2);
    pod2usage( -message => "Unexpected arguments: @arguments", -exitval => 2 ) if @arguments;
    pod2usage( -exitval => 0,                                  -verbose => 1 ) if $help;

    my $PATH = [ split( /:/, ( $ENV{PATH} // q{} ) ) ];
    my $BREW_INSTALL_COMMAND =
'/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"';
    die "Homebrew is not installed.\nInstall it with:\n$BREW_INSTALL_COMMAND\n" unless grep {
        my $p = "$_/" . 'brew';
        -f $p && -x $p;
    } @$PATH;

    my $COMMANDS = [
        [qw(brew update)],
        [qw(brew upgrade -y --cask)],
        [qw(brew upgrade -y)],
        [qw(brew autoremove)],
        [qw(brew cleanup)],
    ];

    for my $command ( @{$COMMANDS} ) {
        run_command( $command, $dry_run );
    }
    return 0;
}

sub run_command {
    my ( $command, $dry_run ) = @_;
    my $command_text = join q{ }, @{$command};
    my $timestamp    = strftime '%Y-%m-%d %H:%M:%S', localtime;

    # Color depends on stdout being a terminal, regardless of stdin.
    if ( -t STDOUT ) {    ## no critic (InputOutput::ProhibitInteractiveTest)
        print "\e[36m[$timestamp]\e[0m \e[32m$command_text\e[0m\n";
    }
    else {
        print "[$timestamp] $command_text\n";
    }
    return if $dry_run;

    my $status = system @{$command};
    die "failed to execute $command_text: $!\n" if $status == -1;
    die sprintf "%s terminated by signal %d\n", $command_text, ( $status & 127 )
        if $status & 127;
    my $exit_code = $status >> 8;
    die "$command_text exited with status $exit_code\n" if $exit_code != 0;
    return;
}
