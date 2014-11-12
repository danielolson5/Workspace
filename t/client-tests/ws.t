use Test::More;
use Config::Simple;
use JSON;
use Data::Dumper;

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

my $url = "http://" . $cfg->param('workspace.service-host') . 
	  ":" . $cfg->param('workspace.service-port');

ok(system("curl -h > /dev/null 2>&1") == 0, "curl is installed");
ok(system("kbase-login > /dev/null 2>&1") == 0, "kbase-login is installed");
ok(system("kbase-logout > /dev/null 2>&1") == 0, "kbase-logout is installed");

ok(system("curl $url > /dev/null 2>&1") == 0, "$url is reachable");
ok(system("kbase-login kbasetest -p @Suite525 > /dev/null 2>&1")==0, "user can log in");
ok(system("kbase-logout > /dev/null 2>&1")==0, "kbase-logout is installed");

BEGIN {
	use_ok( Bio::P3::Workspace::WorkspaceClient );
	use_ok( Bio::P3::Workspace::WorkspaceImpl );
}

can_ok("Bio::P3::Workspace::WorkspaceClient", qw(
		create_workspace
		save_objects
		create_upload_node
		get_objects
		get_objects_by_reference
		list_workspace_contents
		list_workspace_hierarchical_contents
		list_workspaces
		search_for_workspaces
		search_for_workspace_objects
		create_workspace_directory
		copy_objects
		move_objects
		delete_workspace
		delete_objects
		delete_workspace_directory
		reset_global_permission
		set_workspace_permissions
		list_workspace_permissions

   )
);

# create a client
isa_ok ($obj = Bio::P3::Workspace::WorkspaceClient->new(), Bio::P3::Workspace::WorkspaceClient);

# create a workspace without auth
$create_workspace_params = {
	workspace => "brettin",
	permission => "a",
	metadata => {'owner' => 'brettin'}, 
};

ok($output = $obj->create_workspace($create_workspace_params), "create_workspace returns defined");

# create a workspace with auth

# add an object to a workspace


# delete an object from a workspace


