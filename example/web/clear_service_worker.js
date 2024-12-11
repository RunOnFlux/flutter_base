window.addEventListener('load', function (ev) {
    if ('serviceWorker' in navigator) {
        var seconds = new Date().getTime();
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.open("GET", '/version.json?v=' + seconds, true);
        xmlhttp.addEventListener('load', function () {
            if (xmlhttp.status == 200) {
                var res = xmlhttp.responseText;
                try {
                    var json = JSON.parse(res);
                    var buildNumber = json['build_number'];
                    console.log('remote version is ' + buildNumber);
                    var currentBuildNumber = window.localStorage.getItem('build_number');

                    console.log('local version is ' + currentBuildNumber);
                    // clear worker cache if remote and local version are different
                    if (currentBuildNumber != buildNumber) {
                        console.log('App update is necessary. Clearing service workers cache');
                        Promise.all([
                            caches.delete('flutter-app-manifest'),
                            caches.delete('flutter-temp-cache'),
                            caches.delete('flutter-app-cache')
                        ]).then(function () {
                            console.log('Service workers cache cleared');
                        }).catch(function (error) {
                            console.log('Service workers cache clearing failed');
                            console.log(error);
                        }).finally(function () {
                            window.localStorage.setItem('build_number', buildNumber);
                            console.log('Launching app anyway');
                            launchFlutter();
                        });


                    } else {
                        console.log('App is up to date');
                        console.log('Launching app anyway');
                        launchFlutter();
                    }
                } catch (e) {
                    console.log(e);
                    launchFlutter();
                }
            }
        });

        xmlhttp.addEventListener('error', function () {
            launchFlutter();
        });

        xmlhttp.addEventListener('abort', function () {
            launchFlutter();
        });

        xmlhttp.addEventListener('timeout', function () {
            launchFlutter();
        });

        xmlhttp.send();
    } else {
        console.log('Service worker not found. Continue app loading.');
        launchFlutter();
    }
});