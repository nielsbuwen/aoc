function string:split_at(index)
    local first = string.sub(self, 1, index)
    local second = string.sub(self, index + 1)

    return first, second
end
