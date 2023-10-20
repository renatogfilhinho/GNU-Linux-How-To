#!/bin/bash

# Função para realizar um teste de ping e exibir o resultado em uma janela animada do whiptail
realizar_teste_ping() {
    ip=$1
    resultado_file="/tmp/ping_result.txt"
    
    # Iniciar uma janela animada do whiptail
    (
        {
            for i in {1..4}; do
                sleep 1
                echo $((25 * i))
            done
            ping -c 4 "$ip" > "$resultado_file" 2>&1
            echo "100"
        } | whiptail --gauge "Realizando o teste de ping..." 7 50 0
    )
    
    # Exibir o resultado do teste de ping a partir do arquivo temporário
    whiptail --title "Resultado do Teste de Ping" --textbox "$resultado_file" 20 60
    rm "$resultado_file" # Remover o arquivo temporário
}

# Exibe a data e a hora atuais em uma janela do whiptail
mostrar_data_e_hora() {
    data_hora=$(date)
    whiptail --title "Data e Hora Atuais" --msgbox "Data e Hora Atuais:\n\n$data_hora" 10 40
}

# Exibe o menu e lê a escolha do usuário
while true; do
    opcao=$(whiptail --title "Menu" --menu "Escolha uma opção:" 15 40 4 \
        "1" "Realizar teste de ping" \
        "2" "Repetir teste de ping" \
        "3" "Mostrar data e hora" \
        "4" "Desligar" 3>&1 1>&2 2>&3)

    # Verifica a escolha do usuário
    case $opcao in
        1)
            ip=$(whiptail --inputbox "Digite o IP para o teste de ping:" 10 40 3>&1 1>&2 2>&3)
            if [ -n "$ip" ]; then
                realizar_teste_ping "$ip"
            else
                whiptail --msgbox "IP inválido. Tente novamente." 10 40
            fi
            ;;
        2)
            if [ -n "$ip" ]; then
                realizar_teste_ping "$ip"
            else
                whiptail --msgbox "IP inválido. Tente novamente." 10 40
            fi
            ;;
        3)
            mostrar_data_e_hora
            ;;
        4)
            whiptail --yesno "Tem certeza de que deseja desligar o computador?" 10 40
            if [ $? -eq 0 ]; then
                shutdown -h now
            fi
            ;;
        *)
            whiptail --msgbox "Opção inválida. Por favor, escolha 1, 2, 3 ou 4." 10 40
            ;;
    esac
done
