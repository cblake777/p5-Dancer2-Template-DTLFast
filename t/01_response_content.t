use Test::More tests => 6;
use Plack::Test;
use HTTP::Request::Common;

{
	package MyApp;
	use Dancer2;

	set template => 'DTLFast';
	set engines  => {
		template => {
			DTLFast => { },
		},
	};

	get '/layout1' => sub { template 'page', { layout => 'layout1', title => 'layout 1' } };
	get '/layout2' => sub { template 'page', { layout => 'layout2', title => 'layout 2' } };
}

my $app   = MyApp->to_app;
my $plack = Plack::Test->create($app);

test_psgi $app, sub {
	my $res = $plack->request( GET '/layout1' );
	is( $res->code, 200, '[GET /layout1] Request successful' );
	like( $res->content, qr/hello, world/, '[GET /layout1] Correct content' );
	like( $res->content, qr/layout 1 used/, '[GET /layout1] Layout 1 detected' );
};

test_psgi $app, sub {
	my $res = $plack->request( GET '/layout2' );
	is( $res->code, 200, '[GET /layout2] Request successful' );
	like( $res->content, qr/hello, world/, '[GET /layout2] Correct content' );
	like( $res->content, qr/layout 2 used/, '[GET /layout2] Layout 2 detected' );
};

done_testing;
