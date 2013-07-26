# ArchiveLister

Queries the Wayback Machine for URLs associated with a given root

## Installation

Add this line to your application's Gemfile:

    gem 'archive_lister'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install archive_lister

## Usage

Has a bin 'arcl', usage:

```
arcl version 0.0.1
Options:
  --input-file, -i <s>:   File from which to draw the urls
  --output-dir, -o <s>:   Dir to output files (requires --input-file)
   --skip-existing, -s:   Skip existing files when in batch
         --verbose, -v:   Print failures at finish
         --version, -e:   Print version and exit
            --help, -h:   Show this message
```

### Examples

```shell
  arcl http://somewhere.com
```

### Batch

```shell
  arcl -i urls.txt -o data/wayback -v -s
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
