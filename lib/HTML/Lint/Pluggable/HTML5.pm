package HTML::Lint::Pluggable::HTML5;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use parent qw/ HTML::Lint::Pluggable::WhiteList /;
use List::MoreUtils qw/any/;

my %html5_tag = map { $_ => 1 } qw/article aside audio canvas command datalist details embed figcaption figure footer header hgroup keygen mark menu meter nav output progress section source summary time video rp rt ruby wbr/;

my %html5_global_attr = map { $_ => 1 } qw/contenteditable contextmenu draggable dropzone hidden role spellcheck/;
my @html5_global_user_attr = (qr/^aria-/, qr/^data-/);
my %html5_attr = (
    a        => +{ map { $_ => 1 } qw/media/ },
    area     => +{ map { $_ => 1 } qw/media hreflang rel/ },
    base     => +{ map { $_ => 1 } qw/target/ },
    meta     => +{ map { $_ => 1 } qw/charset/ },
    input    => +{ map { $_ => 1 } qw/autofocus placeholder form required autocompletemin max multiple pattern step dirname formaction formenctype formmethod formnovalidate formtarget/ },
    select   => +{ map { $_ => 1 } qw/autofocus form required/ },
    textarea => +{ map { $_ => 1 } qw/autofocus placeholder form required dirname maxlength wrap/ },
    button   => +{ map { $_ => 1 } qw/autofocus formaction formenctype formmethod formnovalidate formtarget/ },
    output   => +{ map { $_ => 1 } qw/form/ },
    button   => +{ map { $_ => 1 } qw/form/ },
    label    => +{ map { $_ => 1 } qw/form/ },
    object   => +{ map { $_ => 1 } qw/form/ },
    fieldset => +{ map { $_ => 1 } qw/form disabled/ },
    form     => +{ map { $_ => 1 } qw/novalidate/ },
    menu     => +{ map { $_ => 1 } qw/type label/ },
    style    => +{ map { $_ => 1 } qw/scoped/ },
    script   => +{ map { $_ => 1 } qw/async/ },
    html     => +{ map { $_ => 1 } qw/manifest/ },
    link     => +{ map { $_ => 1 } qw/sizes/ },
    ol       => +{ map { $_ => 1 } qw/reversed/ },
    iframe   => +{ map { $_ => 1 } qw/sandbox seamless srcdoc/ },
);

sub init {
    my($class, $lint) = @_;
    $class->SUPER::init($lint => +{
        rule => +{
            'elem-unknown' => sub {
                my $param = shift;
                return 1 if $html5_tag{$param->{tag}};
                return 0;
            },
            'attr-unknown' => sub {
                my $param = shift;
                return 1 if $html5_global_attr{$param->{attr}};
                return 1 if $html5_attr{$param->{tag}}{$param->{attr}};
                return 1 if any { $param->{attr} =~ $_ } @html5_global_user_attr;
                return 0;
            },
        }
    });
}

1;
__END__

=head1 NAME

HTML::Lint::Pluggable::HTML5 - allow HTML5 tags and attributes.

=head1 VERSION

This document describes HTML::Lint::Pluggable::HTML5 version 0.01.

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
