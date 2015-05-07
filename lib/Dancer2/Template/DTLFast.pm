# ABSTRACT: DTL::Fast engine for Dancer2
package Dancer2::Template::DTLFast;
$Dancer2::Template::DTLFast::VERSION = '0.002';
use strict;
use warnings;

use Moo;
use Carp qw/croak/;
use Dancer2::Core::Types;

use DTL::Fast qw(get_template);

with 'Dancer2::Core::Role::Template';

# The layout is handled by DTL::Fast by use of an "extends" tag, the name
# of the layout is passed through to the template as a variable used within
# the "extends" tag.
#
#	Example: 
#		{% extends layout %}
#
# We override the apply_layout method from Dancer2::Core::Role::Template here 
# to tell it to just return what apply_render has already processed.
sub apply_layout {
    return $_[1];
}

sub render {
	my ( $self, $template, $tokens ) = @_;

	( ref $template || -f $template ) or croak "$template is not a regular file or reference";

	my ($templateFile) = (split(/\//,$template))[-1];

	my $config = $self->settings->{engines}{template}{DTLFast};
	$config->{dirs} ||= [ $self->views ];

	## The Dancer2 layout system doesn't appear to be accessible here, but you can specify a
	## layout file via a layout token and it will be passed through to the template.
	## maybe use a less generic name?
	my $layout = $tokens->{layout} || $self->layout || $self->config->{layout};
	$tokens->{layout} = ($layout) ? $self->layout_dir . "/" . $self->_template_name($layout) : '';

	my $tpl = get_template(
		$templateFile,
		%$config,
	) or croak "Could not find template $templateFile in " . $self->{views};

	my $content = $tpl->render($tokens);

	return $content;
}

1;

__END__
