return {
    "pwntester/octo.nvim",
    -- pin to f09ff9413652e3c06a6817ba6284591c00121fe0 until we upgrade to GHE > 3.14
    -- https://github.com/pwntester/octo.nvim/issues/685
    commit = "f09ff9413652e3c06a6817ba6284591c00121fe0",
    pin = true,
    opts = {
        default_to_projects_v2 = false,
    },
}
