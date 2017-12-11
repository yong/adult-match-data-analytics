Setup
=========
export REDSHIFT_HOST="nci-test.coc6hp4nwupw.us-east-1.redshift.amazonaws.com"
export REDSHIFT_DB="dev"
export REDSHIFT_USERNAME="awsuser"
export REDSHIFT_PASSWORD=""
* rake db:setup

Note:
========
* offical activerecord5-redshift-adapter does not work with active record 5.1, used a forked one.

* text, json column does not work

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
NciMatchPatientModels::Patient.query_patient_by_id('1')
NciMatchPatientModels::Patient.find_by().count
MongoPatient.first
