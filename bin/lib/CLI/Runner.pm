package CLI::Runner;
use strict;
use warnings;
use utf8;
use POSIX qw(strftime);
use feature 'say';

sub new {
    my ($class, %args) = @_;

    my $is_tty = $args{is_tty} // -t STDOUT;
    my $timestamp_color = $args{timestamp_color} // ($is_tty ? "\e[36m" : q{});
    my $command_color = $args{command_color} // ($is_tty ? "\e[32m" : q{});
    my $reset_color = $args{reset_color} // ($is_tty ? "\e[0m" : q{});

    return bless {
        is_tty  => $is_tty,
        timestamp_color => $timestamp_color,
        command_color => $command_color,
        reset_color => $reset_color,
    }, $class;
}

sub _colorize {
    my ($class, $text, $color) = @_;
    return "$color$text$class->{reset_color}";
}

sub run {
    my ($class, $command, $options) = @_;
    $options //= {};
    my $dry_run = $options->{dry_run} // 0;
    my $print_command = $options->{print_command} // 1;

    my $command_text = join q{ }, @{$command};
    my $timestamp = strftime '%Y-%m-%d %H:%M:%S', localtime;

    # format: [timestamp] command
    my $msg = [
        $class->_colorize("[$timestamp]", $class->{timestamp_color}),
        $class->_colorize($command_text, $class->{command_color}),
    ];
    say join q{ }, @$msg if $print_command;
    system @{$command} unless $dry_run;

    if ($? == -1) {
        die "failed to execute $command_text: $!\n";
    }
    if ($? & 127) {
        die sprintf "%s terminated by signal %d\n", $command_text, ($? & 127);
    }

    my $exit_code = $? >> 8;
    if ($exit_code != 0) {
        die sprintf "%s exited with status %d\n", $command_text, $exit_code;
    }
}

1;
