# test-sdk
This project is using on Gitlab CI/CD to run the ClamAV and VirusTotal scan check automatically when you commit target scan file into folder scan_file. If passed the test, script will commit target scan file to project "clean_zone" then user can download it without any issue.

The following is the preconfig step before scan:

1. User need to prepared the API key of VirusTotal and fill in variable $virustotal_api_key on file test_virustotal.sh
2. User need to create a Gitlab project named "clean_zone"
3. User need to generate a personal access token on Gitlab and fill in variable $gitlab_user_email / $gitlab_user_id / $gitlab_user_token on file .gitlab-ci.yml

The following is the scan step(Only 1):

1. Commit file to folder "scan_file" and waiting for script completion.
