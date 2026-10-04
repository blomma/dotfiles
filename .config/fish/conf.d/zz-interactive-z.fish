# Keep this separate from Fisher's z.fish so plugin updates preserve the guard.
if not status is-interactive
    function __z_disable_noninteractive_tracking --on-event z_install --on-event z_update
        functions --erase __z_on_variable_pwd
    end
    __z_disable_noninteractive_tracking
end
