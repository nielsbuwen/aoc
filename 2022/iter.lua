local function chunked(chunk_size, stateful_iterator)
    local done = false
    local chunk = 0

    return function()
        if done then return nil end

        chunk = chunk + 1
        local lines = {}

        for _ = 1, chunk_size do
            local result = stateful_iterator()

            if not result then
                if #lines == 0 then return nil end

                done = true
                return chunk, lines
            end

            lines[#lines + 1] = result
        end

        return chunk, lines
    end
end

return {
    chunked = chunked
}
