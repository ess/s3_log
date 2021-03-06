## S3Log ##

Naively log events to a file on S3

## Gem Setup ##

```ruby
gem install s3_log

# Gemfile
gem 's3_log'
```

## Configuration ##

S3Log requires an AWS access key id, AWS secret access key, and a S3 bucket (preferably created in advance) name to function. It can be configured (in a Rails initializer or what have you) like so:

```ruby
S3Log.configure(
  access_key_id: 'YOUR AWS ACCESS KEY ID',
  secret_access_key: 'YOUR AWS SECRET ACCESS KEY',
  bucket: 'YOUR S3 BUCKET'
)
```

## Usage ##

Basically, logging an event is a matter of using S3Log.write to write content to a given file location on S3. The file does not have to exist prior to writing, and a write always appends to an existing file.

```ruby
S3Log.write('path/to/file', 'Some content')
```

## Caveats ##

There is no locking in this process, and an existing file will always be read and appended rather than blindly replaced. That being the case, near-simultaneous writes are won by the most recent write, and you would do well to do one of the following to avoid data loss:

* Ensure that only one process writes to a given file at a time
* Use a new file path for each write (ie models/user/1/TIMESTAMP.log rather than models/user/1.log)

## Formal Documentation ##

The actual library docs can be read
[over on rubydoc](http://rubydoc.info/gems/s3_log/frames).

## Contributing ##

Do you use git-flow? I sure do. Please base anything you do off of
[the develop branch](https://github.com/ess/s3_log/tree/develop).

1. Fork it.
2. Perform some BDD magic. Seriously. Be testing.
3. Submit a pull request.

## License ##

MIT License. Copyright 2015 Dennis Walters
