namespace :redshift do
  desc "move data from s3 to redshift using COPY command"
  task etl: :environment do
    # setup AWS credentials
    Aws.config.update({
      region: 'us-east-1',
      credentials: Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY'])
    })

    # connect to Redshift
    db = PG.connect(
      host: ENV['REDSHIFT_HOST'],
      port: ENV['REDSHIFT_PORT'],
      user: ENV['REDSHIFT_USER'],
      password: ENV['REDSHIFT_PASSWORD'],
      dbname: ENV['REDSHIFT_DATABASE'],
    )

    # clear existing data for this table
    db.exec <<-EOS
    TRUNCATE #{TABLE}
    EOS

    # load the data, specifying the order of the fields
    db.exec <<-EOS
    COPY #{TABLE} (#{COLUMNS.join(', ')})
    FROM 's3://#{BUCKET}/#{TABLE}/data'
    CREDENTIALS 'aws_access_key_id=#{ENV['AWS_ACCESS_KEY_ID']};aws_secret_access_key=#{ENV['AWS_SECRET_ACCESS_KEY']}'
    CSV
    EMPTYASNULL
    GZIP
    EOS
  end

end
