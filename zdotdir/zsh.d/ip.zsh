alias show-ip='ip a show dev eth0 | grep '\''inet '\'' | awk '\''{gsub("/.*", ""); print $2}'\'''
alias show-ip6='ip a show dev eth0 | grep '\''inet6'\'' | awk '\''{gsub("/.*", ""); print $2}'\'''
