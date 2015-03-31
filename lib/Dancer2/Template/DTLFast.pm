# ABSTRACT: DTL::Fast engine for Dancer2
package Dancer2::Template::DTLFast;
$Dancer2::Template::DTLFast::VERSION = '0.1';
use strict;
use warnings;

use Moo;
use Carp qw/croak/;
use Dancer2::Core::Types;

use DTL::Fast qw(get_template);

with 'Dancer2::Core::Role::Template';

sub render {
	my ( $self, $template, $tokens ) = @_;

	( ref $template || -f $template ) or croak "$template is not a regular file or reference";

	my ($templateFile) = (split(/\//,$template))[-1];

	my $config = $self->settings->{engines}{template}{DTLFast};
	$config->{dirs} ||= [ $self->views ];

	my $tpl = get_template(
		$templateFile,
		%$config,
	) or croak "Could not find template $templateFile in " . $self->{views};

	my $content = $tpl->render($tokens);

	return $content;
}

1;

__END__
