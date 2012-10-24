jenkins-changelog
=================

Ruby script that generates a change log suitable for submitting new version to HockeyApp.

What it does
------------

This script uses the [Jenkins remote access API](https://wiki.jenkins-ci.org/display/JENKINS/Remote+access+API) in order to get all changes since the last build. It then creates a file called `change.log` in the same directory with the following format:

	* commit message (author)
	* commit message (author)
	...
	
The maximum length is set to **5000** characters. If it doesn't fit all the commits, it will terminate the change log like this:

	* ...
	* commit message (author)
	* And many more ...

Run it
------

Add the ruby script to your project and commit it. Make sure ruby is installed on Jenkins. Then configure your Jenkins job to use the build step "execute shell". Enter the following line:

	$ ruby ./changelog.rb

The script will write a file called `change.log` into the same directory. To get the proper data it uses two environment variables, set by Jenkins. It's the current job (`ENV['JOB_NAME']`) and build (`ENV['BUILD_NUMBER']`).

HockeyApp
---------

You can use the contents of this file when uploading new versions to [HockeyApp](http://www.hockeyapp.net). If you upload a new version via their [API](http://support.hockeyapp.net/kb/api/api-upload-new-versions) you can pipe the contents to the `notes` parameter:

	curl \
		-F "status=2" \
		-F "notify=0" \
		-F "notes=$(cat change.log)" \
		-F "notes_type=0" \
		...
		https://rink.hockeyapp.net/api/2/apps/XYZ/app_versions'

Contribute
----------

The current version is very simple. If you miss something, feel free to contribute.