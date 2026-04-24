@settings = {}

def set option, value
    @settings[option] = value
end
def enable option
    self.set option, true
end
def disable option
    self.set option, false
end