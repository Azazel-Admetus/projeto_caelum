import pandas as pd
from difflib import get_close_matches

# Carregando o arquivo CSV
file = 'dados.csv'
dados = pd.read_csv(file)

# Criando o dicionário de perguntas e respostas sem padronizar
dicionario = {row['pergunta']: row['resposta'] for _, row in dados.iterrows()}

# Função para buscar a resposta
def buscarresposta(user_quest, dicionario):
    if user_quest in dicionario:
        return dicionario[user_quest]
    similaridade = get_close_matches(user_quest, dicionario.keys(), n=1, cutoff=0.6)
    if similaridade:
        return dicionario[similaridade[0]]
    else:
        return "Desculpe, não consegui entender sua pergunta. Tente reformular ou verificar erros ortográficos."


import pyttsx3
voz = pyttsx3.init()
voices = voz.getProperty('voices')

for voice in voices:
    if "portuguese" in voice.languages or "português" in voice.name.lower():
        voz.setProperty('voice', voice.id)
        break

voz.setProperty('rate', 200)
voz.setProperty('volume', 1)
from random import choice 
from time import sleep

   
# Interação com o usuário
print("Solum Basileus: Estou aqui para responder suas perguntas!")
while True:
    quest = input("Você: ")
    if quest in ['sair', 'exit', 'quit']:
        print("Muito obrigado por ter interagido comigo!")
        break
    resposta = buscarresposta(quest, dicionario)
    print("Solum: ")
    print(resposta)
    voz.say(resposta)
    voz.runAndWait()
    sleep(2)