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

	## Currently, the options passed in to the template are not sent on via dancer to the apply_renderer 
	## method, only to the apply_layout method, which means it is current impossible to see during the 
	## rendering of the template if the user has passed in an override for the layout. As such, if the
	## user wants to take advantage of Dancer2's "layout" system and is wanting to use a custom layout
	## for a single request, then they need to specify the name of the template as a token, not an 
	## option, for it to be detected.
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
