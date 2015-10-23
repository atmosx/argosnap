# Argosnap
Argosnap is a ruby script that displays your current [tarsnap](http://www.tarsnap.com/) ballance in [picoUSD](http://www.tarsnap.com/picoUSD-why.html). The script can send notifications when the account balance falls below the predefined threshold. Argosnap supports email, [pushover](https://pushover.net/) and [OSX notifications](https://support.apple.com/en-us/HT204079).

# Installation

## Linux, *BSD and MacOSX
In order to run `argosnap` you need only the [mechanize](https://github.com/sparklemotion/mechanize) gem. If you want to use receive [HTML](https://en.wikipedia.org/wiki/HTML) email notifications you are going to need the `haml` as well and `mail` gem. In case you want TXT email, you are going to need only the `mail` gem.

Install the gems via rubygems:

    $ gem install mail mechanize haml argosnap

## MacOSX Launchd
If you want to use OSX notifications, you need to instal `plist` and `terminal-notifier` too. To install the gems type:
    
    $ gem install mail mechanize haml plist terminal-notifier argosnap
    
# Configure

Run the following command for the script to create a configuration file like: 

    $ argosnap -i config

You'll see the location of the newly created configuration file on your terminal. Then you need to configure the `config.yml` file which looks like this:
    
    ---
    :email: tarsnap_email@domain.net
    :password: tarsnap_password
    :threshold: 10
    :seconds: 86400
    :notifications_osx: false
    :notifications_email: true
    :smtp:
      :email_delivery_method: smtp
      :smtpd_user: my_smtp_user
      :smtpd_password: my_smtp_password
      :smtpd_address: smtp.domain.net
  :smtpd_port: 465
  :smtpd_from: no-reply@domain.net
  :smtpd_to: user@domain.net
  :format: txt
:notifications_pushover: false
:pushover:
  :key: <my-hash-key>
  :token: <app-token-key>

TODO

# Contributing

1. Fork it ( http://github.com/atmosx/argosnap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
