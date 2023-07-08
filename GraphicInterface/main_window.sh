#!/bin/bash


# Array com as opções disponíveis
opcoes=("Git" "Opção 2" "Opção 3" "Opção 4")

# Construir a lista de opções para o Zenity
lista_opcoes=""
for opcao in "${opcoes[@]}"; do
  lista_opcoes+="FALSE '$opcao' "
done

# Exibir a janela com as caixas de seleção e obter as opções selecionadas
resposta=$(zenity --list --checklist --column "" --column "Opções" --separator=" " --title "Selecione as opções" --text "Selecione as opções desejadas:" $lista_opcoes)

# Verificar se o usuário selecionou alguma opção
if [ $? -eq 0 ]; then
    # Exibir as opções selecionadas
    echo "Opções selecionadas:"
    for opcao in $resposta; do
        echo "$opcao"
    done
else
    echo "Nenhuma opção selecionada."
fi
