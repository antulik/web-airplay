githubReleaseReminder = function (options) {

    var current_release_id = options.current_release_id;
    var new_release = null;
    var current_release = null;

    $.get(options.url).success(function (releases) {

        for (var i = 0; i < releases.length; i++) {
            var release = releases[i];

            if (release.id > current_release_id) {
                if (new_release == null || new_release.id < release.id) {
                    new_release = release;
                }
            }

            if (release.id == current_release_id) {
                current_release = release;
            }
        }

        if (new_release) {
            options.on_new_release(current_release, new_release);
        }
    });
};
