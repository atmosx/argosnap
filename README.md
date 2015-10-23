# Argosnap
Argosnap is a ruby script that displays your [tarsnap](http://www.tarsnap.com/) current ballance in [picoUSD]((http://www.tarsnap.com/picoUSD-why.html). The script can send notifications when the account balance falls below the predefined threshold. Argosnap supports email, [pushover](https://pushover.net/) and [OSX notifications](https://support.apple.com/en-us/HT204079).

# Installation

Install the gem via rubygems:

    $ gem install argosnap plist mechanize terminal-notifier

# Configure

Run the following command for the script to create a configuration file like: 

    $ argosnap -i config

You'll see the location of the newly created configuration file on your terminal. Then you need to configure the `config.yml` file which looks like this:
    
    ---
    :email: sample@email.com
    :password: p4sw0rd3
    :threshold: 10
    :seconds: 7200

Just put your tarsnap login credentials. You can omit the other two variables if you are not using an OSX system. To view your account use the command:

    $ argosnap -p


# Configure Launchd under MacOSX

In the `config.yml` adjust the `threshold` and `seconds` options as you see fit. Threshold is the amount of *picodollars* bellow which you'd like to start seeing notifications and the `seconds` consists of the time window. Then type:

    $ argosnap -i cron

Now just start the installed `.plist` file following instruction you'll see on the screen and you're done.

# Options

To run an osx notification use the command:

    $ argosnap -p osx
    Current balance (picodollars): 4.8812

To get the amount of picodollars as an integer type:

    $ argosnap -p clean
    4.8812

That's all :-)

# Contributing

1. Fork it ( http://github.com/atmosx/argosnap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
