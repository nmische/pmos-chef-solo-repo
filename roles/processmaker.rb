name "processmaker"
description "Installs and configures ProcessMaker (pmos)."
# List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
run_list(
	"recipe[apt]",
	"recipe[apache2]",
	"recipe[apache2::mod_php5]",
	"recipe[php]",
	"recipe[mysql::server]",
	"recipe[processmaker]"
)
# Attributes applied if the node doesn't have it set already.
#default_attributes()
# Attributes applied no matter what the node has set already.
#override_attributes()