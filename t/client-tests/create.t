
use strict vars;
use Test::More;
use Test::Exception;
use Config::Simple;
use JSON;
use Data::Dumper;
use UUID;

my($cfg, $url, );

if (defined $ENV{KB_DEPLOYMENT_CONFIG} && -e $ENV{KB_DEPLOYMENT_CONFIG}) {
    $cfg = new Config::Simple($ENV{KB_DEPLOYMENT_CONFIG}) or
	die "can not create Config object";
    pass "using $ENV{KB_DEPLOYMENT_CONFIG} for configs";
}
else {
    $cfg = new Config::Simple(syntax=>'ini');
    $cfg->param('workspace.service-host', '127.0.0.1');
    $cfg->param('workspace.service-port', '7125');
    pass "using hardcoded Config values";
}

$url = "http://" . $cfg->param('workspace.service-host') . 
	  ":" . $cfg->param('workspace.service-port');

ok(system("curl -h > /dev/null 2>&1") == 0, "curl is installed");
ok(system("curl $url > /dev/null 2>&1") == 0, "$url is reachable");

BEGIN {
	use_ok( Bio::P3::Workspace::WorkspaceClient );
	use_ok( Bio::P3::Workspace::WorkspaceImpl );
}

# create a client
my $obj;
isa_ok ($obj = Bio::P3::Workspace::WorkspaceClient->new(), Bio::P3::Workspace::WorkspaceClient);

# create a workspace for each permission value and then delete it

my $perm = 'w';
my $create_workspace_params = {
    workspace => new_uuid("brettin"),
    permission => $perm,
    metadata => {'owner' => 'brettin'},
};

my $output;
ok($output = $obj->create_workspace($create_workspace_params), "can create workspace with perm=$perm");



done_testing();


sub new_uuid {
	my $prefix = shift if @_;

	my($uuid, $string);
	UUID::generate($uuid);
	UUID::unparse($uuid, $string);

	my $return = $string;
	$return = $prefix . '-' . $string if defined $prefix;

	return $return;
}
