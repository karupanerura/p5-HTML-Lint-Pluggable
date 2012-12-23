package HTML::Lint::Pluggable;
use strict;
use warnings;

our $VERSION = '0.01';

use lib "$ENV{HOME}/perl5/perlbrew/perls/perl-5.16.1/lib/site_perl/5.16.1";
use parent qw/ HTML::Lint /;
use Class::Load qw/load_class/;
use Hash::Util::FieldHash qw/fieldhash/;

our $PLUGIN_NAMESPACE = 'HTML::Lint::Pluggable';

sub load_plugins {
    my $self = shift;
    while (@_) {
        my $plugin = shift;
        my $conf   = @_ > 0 && ref($_[0]) eq 'HASH' ? +shift : undef;
        $self->load_plugin($plugin, $conf);
    }
}

sub load_plugin {
    my ($self, $plugin, $conf) = @_;
    $plugin = "${PLUGIN_NAMESPACE}::${plugin}" unless $plugin =~ s/^\+//;
    load_class($plugin);
    $plugin->init($self, $conf);
}

fieldhash my %OVERRIDED_CODES;
my %ROOTCODE;
sub override {
    my($self, $method, $code) = @_;

    my $class = ref $self;
    $OVERRIDED_CODES{$self}          ||= +{};
    $ROOTCODE{$class}                ||= +{};
    $OVERRIDED_CODES{$self}{$method} ||= $ROOTCODE{$class}{$method} || $class->can($method);
    $OVERRIDED_CODES{$self}{$method}   = $code->($OVERRIDED_CODES{$self}{$method});

    unless ($ROOTCODE{$class}{$method}) {
        my $orig = $ROOTCODE{$class}{$method} = $class->can($method);
        my $method_code = sub {
            my $self = shift;

            if (exists $OVERRIDED_CODES{$self}) {
                my $super = $OVERRIDED_CODES{$self}{$method};
                return $self->$super(@_) if $super;
            }

            return $self->$orig(@_);
        };

        no strict 'refs';
        *{"${class}::${method}"} = $method_code;
    }
}

1;
__END__

=head1 NAME

HTML::Lint::Pluggable - Perl extention to do something

=head1 VERSION

This document describes HTML::Lint::Pluggable version 0.01.

=head1 SYNOPSIS

    use HTML::Lint::Pluggable;

    my $lint = HTML::Lint::Pluggable->new;
    $lint->only_types( HTML::Lint::Error::STRUCTURE );
    $lint->load_plugins(qw/HTML5/);

    $lint->parse( $data );
    $lint->parse_file( $filename );

    my $error_count = $lint->errors;

    foreach my $error ( $lint->errors ) {
        print $error->as_string, "\n";
    }

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Kenta Sato E<lt>karupa@cpan.orgE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012, Kenta Sato. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
