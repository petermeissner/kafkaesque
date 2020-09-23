alias kafka_post='echo "123" | kafkacat -P -b localhost -t awesome-topic -e'
alias kafka_get='kafkacat -C -b localhost -t awesome-topic -e'

alias ll='ls -lh'
alias lla='ls -lah'

export PS1="\n{\e[0;34m\$?\e[m} \u@\h - \t -   \e[0;34m\w\e[m\n"

