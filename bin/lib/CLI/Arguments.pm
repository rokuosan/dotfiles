package CLI::Arguments;
use strict;
use warnings;
use utf8;

# Example usage:
# my $parser = CLI::Arguments->new(
#     {
#         name => 'dry-run',
#         alias => 'n',
#         description => 'Only print commands without executing',
#     },
#     {
#         name => 'help',
#         alias => 'h',
#         description => 'Show this help message',
#     },
# );

sub new {
    my ($class, @expected_args) = @_;

    # check for duplicate names or aliases
    my %seen;
    for my $arg (@expected_args) {
        my $name = $arg->{name} or die "Argument definition missing 'name'";
        die "Duplicate argument name: $name" if $seen{$name}++;
        if (my $alias = $arg->{alias}) {
            die "Duplicate argument alias: $alias" if $seen{$alias}++;
        }
    }

    return bless {
        _args => \@expected_args,
    }, $class;
}

sub parse {
    my ($class, @input_args) = @_;
    my %result;

    # create lookup for expected arguments
    my %lookup;
    for my $arg (@{$class->{_args}}) {
        $lookup{'--' . $arg->{name}} = $arg->{name};
        if (my $alias = $arg->{alias}) {
            $lookup{'-' . $alias} = $arg->{name};
        }
    }

    for my $input (@input_args) {
        if (exists $lookup{$input}) {
            my $key = $lookup{$input};
            if (exists $result{$key}) {
                die "Duplicate argument: $input\n";
            }
            $result{$key} = 1;
        } else {
            die "Unknown argument: $input\n";
        }
    }

    return \%result;
}

1;
