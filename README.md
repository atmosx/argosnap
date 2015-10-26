**Argosnap** is a [tarsnap](https://www.tarsnap.com/) utility designed to send notifications when the picoUSD balance falls below a predefined threshold. Currently the following notifications methods are supported:

* [Pushover  notifications.](https://pushover.net/)
* Email notifications
* [OSX notifications](https://support.apple.com/en-us/HT204079)

# Installation

## Linux, *BSD and MacOSX
The main dependency is [mechanize](https://github.com/sparklemotion/mechanize). Install the gems via rubygems:

    $ gem install mail mechanize argosnap
    

# Setup

Run `argosnap` to create the configuration files: 

    $ argosnap -i config

You need to edit the settings accordingly. The configuration file is located at `$HOME/.argosnap/config.yml` and looks like this:
    
    ---
    :email: tarsnap_email@domain.net
    :password: tarsnap_password
    :threshold: 10
    :seconds: 86400
    :notifications_osx: false
    :notifications_email: false
    :smtp:
      :email_delivery_method: smtp
      :smtpd_user: my_smtp_user
      :smtpd_password: my_smtp_password
      :smtpd_address: smtp.domain.net
      :smtpd_port: 465
      :smtpd_from: no-reply@domain.net
      :smtpd_to: user@domain.net
      :format: txt
    :notifications_pushover: true
    :pushover:
      :key: <my-hash-key>
      :token: <app-token-key>

You need to enable notifications to use them. See [the wiki](https://github.com/atmosx/argosnap/wiki) for details on how to setup notifications.

# Usage
Argosnap usage is straight forward:

    $ argosnap -h
    argosnap 0.0.4.1 ( https://github.com/atmosx/argosnap/ )
    Usage: argosnap [OPTIONS]

     -v:           dislay version
     -i config:    install configuration files
     -i plist:     install plist file for OSX
     -p:           prints the current amount in picoUSD
     -p clean:     prints only the picollars (float rounded in 4 decimals), to use in cli
     -n mail:      send notification via email
     -n pushover:  send notification via pushover
     -n osx:       display osx notification
     -n notify:    send notifications everywhere

    -v, --version                    display version
    -i, --install [OPTION]           install configuration files
    -p, --print [OPTION]             fetch current amount in picoUSD
    -n, --notification [OPTION]      send notification via email
    -h, --help                       help
 
    $ argosnap -p
    Current picoUSD balance: 4.287
    $ argosnap -p clean
    4.287


# License

See [License.txt](https://github.com/atmosx/argosnap/blob/master/LICENSE.txt) for details.

# Contributing

1. Fork it ( http://github.com/atmosx/argosnap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
