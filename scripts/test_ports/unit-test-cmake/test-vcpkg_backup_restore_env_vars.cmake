# vcpkg_backup_env_variables(VARS <list>)
# vcpkg_restore_env_variables(VARS <list>)
# These functions used scoped variables and cannot be called in unit_test_check_*.

set(ENV{A} [[::a;::b]])
set(ENV{B} [[]])
vcpkg_backup_env_variables(VARS A B)
unit_test_check_variable_equal([[]] ENV{A} [[::a;::b]])
unit_test_check_variable_equal([[]] ENV{V} [[]])

set(ENV{A} [[::a;::b;::c]])
set(ENV{B} [[::1]])
vcpkg_restore_env_variables(VARS A B)
unit_test_check_variable_equal([[]] ENV{A} [[::a;::b]])
unit_test_check_variable_equal([[]] ENV{V} [[]])

# Backups are scoped.
function(change_and_backup)
    set(ENV{A} [[::a;::b;::c]])
    set(ENV{B} [[::1]])
    vcpkg_backup_env_variables(VARS A B)
    # no further change, no restore, in this scope
endfunction()
vcpkg_backup_env_variables(VARS A B)
change_and_backup()
vcpkg_restore_env_variables(VARS A B)
unit_test_check_variable_equal([[]] ENV{A} [[::a;::b]])
unit_test_check_variable_equal([[]] ENV{V} [[]])
