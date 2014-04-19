# Argosnap

This gem installs a script which displays [OSX notifications](http://support.apple.com/kb/ht5362) when your [tarsnap account](http://www.tarsnap.com/) falls bellow a predefined threshold of [picodollars](http://www.tarsnap.com/picoUSD-why.html).

## Installation

Install the gem via rubygems:

    $ gem install argosnap

## Configure

We need to run `install` for the script to create the configuration file. 


    $ asnap install

Then we configure the `config.yml` file which looks like this:
    
    ---
    :email: sample@email.com
    :password: p4sw0rd3
    :threshold: 10
    :seconds: 7200

These are the default values. Tarsnap email login and password. The `threshold` variables defines the amount of picodollars CONTINUE-HERE

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/argosnap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
