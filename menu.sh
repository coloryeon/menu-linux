#!/bin/bash
#
#Mylena Torquato
#
#Automação de DHCP, APACHE e DNS

#variaveis
#ip e sourcelist

ip="/etc/network/interfaces"
source="/etc/apt/source.list"

#dhcp

arq="dhcpd.conf"
pas="/etc/dhcp"
conf="/etc/dhcp/dhcpd.conf"

#apache

paap="/etc/apache2/sis-available"
ap2="/var/www"

#dns
pasta="/etc/bind"
conf_default="named.conf.default-zones"
resolv="/etc/resolv.conf"

shopt -s -o nounset

menu(){
    clear

    while true 
    do

    echo -e "-/-/-/-/-/-/-/-/-/-/- MENU PRINCIPAL -/-/-/-/-/-/-/-/-/-/-"
    echo -e "1. MENU DHCP"
    echo -e "2. MENU APACHE"
    echo -e "3. MENU DNS"
    echo -e "4. CONFIGURAR IP"
    echo -e "5. CONFIGURAR SOURCE LIST"
    echo -e "6. SAIR"
    echo -e "Selecione a opção desejada: "
    read opcao

    case $opcao in

      1)
        echo "Direcionando para o menu do DHCP"
        dhcp
        ;;

      2)
        echo "Direcionando para o menu do Apache"
        apache
        ;;

      3)
        echo "Direcionando para o menu do DNS"
        dns
      ;;

      4)
        echo "Direcionando para o menu de configuração de IP"
        ipm
      ;;

      5)
        echo "Direcionando para o menu de configuração da Source List"
        list
      ;;

      6)
        echo "Saindo do programa."
        break
        ;;

      *)
        echo "Selecione uma opção válida"
        menu
        ;;

    esac
  done
}

dhcp(){
    xdhcp="continuar"

    while ["$xdhcp" == "continuar"];
    do

        echo "-/-/-/-/-/-/ Menu DHCP -/-/-/-/-/-/"
        echo "1 - Instalar o DHCP"
        echo "2 - Desinstalar o DHCP"
        echo "3 - Configurar o DHCP"
        echo "4 - Iniciar o DHCP"
        echo "5 - Parar o DHCP"
        echo "6 - Reiniciar o DHCP"
        echo "7 - Sair do script"
        echo "-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-"

        echo "Informe a opção desejada: "
        read optiondhcp

        case "$optiondhcp" in

        1)
            #Titulo
            echo "Instalando o DHCP"
            sleep 2
            apt-get install isc-dhcp-server -y
            echo "DHCP instalado com sucesso !"

        ;;

        2)
            echo "Você selecionou a opção 'Desinstalar DHCP', você tem certeza que gostaria de fazer isso? (S / N)"
            read opdhs
            if [ "$opdhs" == "S" | "s" ]; then
                echo "Desinstalando o DHCP"
                sleep 2
                apt-get remove isc-dhcp-server -y
                echo "Servidor DHCP desinstalado com sucesso !! <3"
            else
                echo "Voltando ao Menu do DHCP"
            fi

        ;;

        3)
        #titulo
            echo "Configurando o DHCP"

            echo "Para configurar o DHCP, garanta que o IP do seu servidor esteja correto."
            sleep 2

        
            # Criando backup 
            mv -f /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd-bkp.conf

            #criar novo arquivo e configurar
            echo "Qual é o seu dominio DNS?: "
            read domdns

            echo "Qual é o IP do seu servidor DNS?: "
            read ipdns

            echo "De quanto em quanto tempo os IPS vão reiniciar?: "
            read temp

            echo "Qual o IP da sua rede?: "
            read iprede

            echo "Qual é o começo da range do seu servidor?: "
            read range
            
            echo "Qual é o final da range do seu servidor?: "
            read range2


            rm -f $pas/$arq
            touch $pas/$arq

            echo option domain-name \"$domdns\"\; >> $conf
            echo "option domain-name-servers $ipdns;" >> $conf
            echo "default-lease-time $temp;" >> $conf
            echo "authoritative;" >> $conf
            echo "subnet $iprede netmask $mask {" >> $conf
            echo "          " >> $conf
            echo "  range $range $range2;" >> $conf
            echo "  option subnet-mask $mask;" >> $conf
            echo "  option routers $gateway;" >> $conf
            echo "          " >> $conf
            echo "}" >> $conf

            #Indicar a placa de rede
            echo -e "INTERFACESV4=\"enp0s3\"\nINTERFACESV6=\"\"" > /etc/default/isc-dhcp-server

            echo "DHCP configurado com sucesso"
            sleep 2

            echo "Agora é importante desligar a máquina"
            echo "Ao iniciar altere a configuração da placa de rede"
            echo "Tchauzinho"
            sleep 3

            init 0
        ;;

        4)
            echo "Iniciando o servidor DHCP"
            systemctl start isc-dhcp-server -y
            sleep 2 
        ;;

        5)
            echo "Parando o servidor DHCP"
            systemctl stop isc-dhcp-server -y
            sleep 2
        ;;

        6)
            echo "Reiniciando o servidor DHCP"
            systemctl restart isc-dhcp-server -y
            sleep 2
        ;;

        7)
            echo "Fechando o script"
            break
        ;;

        *)
            echo "Selecione uma opção válida. "

        ;;
        esac
        

    done

} 

apache(){
    xa="continuar"
    while [ "$xap" == "continuar"];
    do

 
        echo -e "-/-/-/-/-/-/-/-/-/-/- MENU APACHE -/-/-/-/-/-/-/-/-/-/-"
        echo -e "1. Instalar servidor Apache"
        echo -e "2. Desinstalar servidor Apache"
        echo -e "3. Iniciar servidor Apache"
        echo -e "4. Parar servidor Apache"
        echo -e "5. Criar no Apache"
        echo -e "6. Git Clone"
        echo -e "7. Sair"
        read opap

    case "$opap" in

        1)

        echo "Instalando o Sevidor apache"
        apt-get install apache2 -y
        sleep 2

        echo "Apach instalado com sucesso!"
        ;;
        
        2)
            echo "Você selecionou a opção 'Desinstalar Apache', você tem certeza que gostaria de fazer isso? (S / N)"
            read opapc
            if [ "$opapc" == "S" | "s" ]; then
                echo "Desinstalando o Apache"
                sleep 2
                apt-get remove apache2 -y
                echo "Servidor Apach desinstalado com sucesso !! <3"
            else
                echo "Voltando ao Menu do Apache"
            fi

        ;;

        3)
            echo "Iniciando o servidor APACHE"
            systemctl start apache2 -y
            sleep 2 
        ;;

        4)
            echo "Parando o servidor APACHE"
            systemctl stop isc-dhcp-server -y
            sleep 2
        ;;

        5)
            echo "Iniciando configuração"

            echo "Qual é o seu dominio? (insira com www, .com ou .local): "
            read si

            echo "Qual é o seu dominio? (insira sem www, .com ou .local): "
            read si2

            mkdir "$ap2/$si2"

            touch "$paap/$si2.conf"

            echo "<VirtualHost *:80>" >> "$paap/$si2.conf"
            echo "      " >> "$paap/$si2.conf"
            echo "  ServerAdmin $si2@$si" >> "$paap/$si2.conf"
            echo "  ServerName $si" >> "$paap/$si2.conf"
            echo "  DocumentRoot $ap2/$si2" >> "$paap/$si2.conf"
            echo '  ErrorLog ${APACHE_LOG_DIR}/error.log' >> "$paap/$si2.conf"
            echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined' >> "$paap/$si2.conf"
            echo "      " >> "$paap/$si2.conf"
            echo "</VirtualHost>" >> "$paap/$si2.conf"

            #desativar e ativar sites
            a2ensite "$si2.conf"
            a2dissite 000-default.conf
            systemctl restart apache2

            echo "Gostaria de adicionar um git clone? (S / N): "
            read res

            if [[ $res == "S" | "s" ]]; then
                echo "Instalando github :)"
                apt-get install git -y
                sleep 2

                echo "Insira aqui o link do git clone: "
                read gi

                git clone "$gi" "$ap2/$si2"

                echo "Concluido"
            else 
                echo "Ok..."
            fi
        ;;


        6)
            echo "Instalando github"
            apt-get install git -y
            sleep 3

            echo "Adicione o link do seu git clone: "
            read git

            echo "Por favor, adicione aqui o nome do seu site: "
            read namepg

            git clon $git $ap2/$namepg
            echo "Concluido <3"

        ;;


        7)
            echo "Fechando o script"
            break
        ;;

        *)
            echo "Selecione uma opção válida. "

        ;;
        esac
        

    done


    
}

dns(){
  clear
    xdns="continuar"


  while [ "xdns" == "continuar" ];
  do

    echo -e "            MENU            "
    echo -e "1. Instalar servidor DNS"
    echo -e ""
    echo -e "2. Desinstalar servidor DNS"
    echo -e ""
    echo -e "3. Iniciar servidor DNS"
    echo -e ""
    echo -e "4. Parar servidor DNS"
    echo -e ""
    echo -e "5. Criar e configurar zonas"
    echo -e ""
    echo -e "Selecione a opção deseja"
    read option

    case $option in

      1)
        echo "Instalando servidor..."
        apt-get install bind9
        sleep 3
        ;;

      2)
        echo "Você escolheu DESINSTALAR O SERVIDOR!!"
        echo "Você tem certeza disso?? (S / N): "
        read resp
        if [[ "$resp" == "S" || "$resp" == "s" ]]; then
          apt-get remove bind9
        else
          break
        fi
    ;;

      3)
        echo "Iniciando servidor DNS"
        systemctl start bind9

        ;;

      4)
        echo "Você escolheu PARAR O SERVIDOR DNS"
        systemctl stop bind9

        ;;

      5)
        echo "Criando zonas"
              # Criando zonas
        while [[ loop==true ]]; do
          echo "Qual é o nome da zona que você deseja criar?:* (google, youtube, npc...)"
          read zone
          echo "Final da zona que deseja colocar:* (.local, .com, ...)"
          read end
          # named.conf.default-zones
          zona_compl="$zone$end"
          zona_local="$pasta/db.$zone"
          {
            echo "zone @" {
            echo "      type master;"
            echo "      file =;"
            echo -e "};\n"

            sed -i 's/@/"x"/g' $conf_default
            sed -i "s|x|$zona_compl|g" $conf_default
            sed -i 's/=/"+"/g' $conf_default
            sed -i "s|+|$zona_local|g" $conf_default
          } >>"$conf_default"

          echo "Início da zona que seja colocar:* (www, ns1, ...)"
          read inin
          echo "IP do server WEB:* "
          read ip_servico
          # Criando db
          localhost="ns1.$zone"
          touch "$zona_local"
          {
            echo -e "; BIND reverse data file for empty rfc1918 zone\n;\n; DO NOT EDIT THIS FILE - it is used for multiple zones.\n; Instead, copy it, edit named.conf, and use that copy.\n;\n=TTL 86400\n@ >"
            echo "$inin     IN      A       $ip_servico"
            sed -i "s|=|$|" "$pasta/db.$zone"
            sed -i "s|localhost|$localhost|g" "$pasta/db.$zone"
          } >>"$pasta/db.$zone"

          echo "Deseja adicionar mais uma zona? (S / N): "
          read verif
          while [[ "$verif" == "S" || "$verif" == "s" ]]; do
            echo "Início da zona que seja colocar (www, ns1, ...): "
            read start
            echo "IP do server WEB:* "
            read ip_servico
            {
              echo "$start    IN      A       $ip_servico"
            } >>"$pasta/db.$zone"

            echo "Deseja adicionar mais um início de zona? (S / N)"
            read verif
          done

          echo "Deseja adicionar mais uma zona? (S / N)"
          read verificar
          if [[ "$verificar" == "N" || "$verificar" == "n" ]]; then
            break
          fi
        done
        ;;

      *)
        echo "Opção invalida"
        ;;

    esac
  done
}

ipm(){

    xip="continuar"

    while ["$xip" == "continuar"];
    do

    echo "-/-/-/-/-/-/-/-/-/-/- Configuração de IP -/-/-/-/-/-/-/-/-/-/-"
    echo -e "1. Configuar o IP"
    echo -e "2. Sair do menu de IP"
    read opis

    case $opis in

    1)
        echo "Vamos configurar o IP do seu sistema!"
        echo "Qual IP você gostaria de colocar no seu servidor?: "
        read ipes

        echo "Qual a máscara da sua rede?: "
        read mask

        echo "Qual é o seu Gateway?: "
        read gateway

        echo "source /etc/network/interface.d/*" > $ip
        echo "auto lo" >>$ip
        echo "iface lo inet loopback" >>$ip
        echo "allow-hotplug enp0s3" >>$ip
        echo "iface enp0s3 inet static" >>$ip
        echo "address $ipes" >>$ip
        echo "netmask $mask" >>$ip
        echo "gateway $gateway" >>$ip

            #Reiniciar a placa de rede
        systemctl restart networking.service

        echo "IP configurado com sucesso !! :)"
        sleep 2

    ;;

    2)
        echo "Voltando ao menu principal"
        sleep 2
    ;;
    esac
done    
}

list(){
        echo -e "SOURCE LIST"
        echo -e "1. debian 10"
        echo -e ""
        echo -e "2. debian 11"
        echo -e ""
        echo -e "3. debian 12"
        echo -e ""
        echo -e " 4. voltar "
        echo -e ""
        echo -e "Escolha uma das opções"
        read -e opn2
        echo "------------------------------------------------------------------------------"
    case "$opn2" in
        1)
            echo "deb http://deb.debian.org/debian buster main contrib non-free" > $source
            echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> $source
            sleep 2
            ;;
        2)
            echo "deb http://deb.debian.org/debian bullseye main contrib non-free" > $source
            echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free" >> $source
            sleep 2
            ;;
        3)
            echo "deb http://deb.debian.org/debian bookworm main non-free-firmware" > $source
            echo "deb-src http://deb.debian.org/debian bookworm main non-free-firmware" >> $source
            sleep 2
            ;;
        4)
            echo "Voltando para o menu"
            sleep 2
            menu
            ;;
        *)
            echo "opção invalida"
            ;;
    esac
}






