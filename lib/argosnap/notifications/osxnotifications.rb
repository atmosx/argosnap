module OSXnotify
  def self.send(message, title, subtitle)
    TerminalNotifier.notify(message, :title => title, :subtitle => subtitle) 
  end
end
