@settings = {}

# sets an option to a value (usually true or false)
def set option, value
    @settings[option] = value
end

# sets an option to true
# @see #set
def enable option
    self.set option, true
end

# sets and option to false
# @see #set
def disable option
    self.set option, false
end