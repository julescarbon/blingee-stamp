var AESBase64 = new require("./lib/aes")

cipher = "ojJLnyRWNyyTliwhskbTAW/AYIqmCty4nu/14kohm5y0imcIruRc7aNo2tfACWuzbOLyM7yGdrOvvQAPfqOga1jOaUSeO69yxMJOW3hNHtaK+2s1P9r8efqcc555bznLKtzFbtCezz/PsWvaUPmh5l07ELNQlM8HFP4yiFrqbiLU7H+j2sQo4tuReDjtJDnd8BGBSlgFJhMnVaKGLeyyJ85vvjWfEUaoiz/AnF7CChUN1eHVpMpsba+OOe6+ZdOBxDi3pZqNUbkZQKyTZDoq9lhcR1LmMMYcmqBZ8kRG+KpseuGbOdFeiW9mb+cytsRh"
key = "rAI1P8bpXoReutED8XOTT0lh26MWhWz87IH4t39LjJp3wxLkEHDKE2Er"

aes = new AESBase64(128,128)
ss = aes.decrypt(cipher, key, "ECB")
console.log(ss)
