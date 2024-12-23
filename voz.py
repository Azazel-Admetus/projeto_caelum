import pyttsx3
voz = pyttsx3.init()
voices = voz.getProperty('voices')

for voice in voices:
    if "portuguese" in voice.languages or "português" in voice.name.lower():
        voz.setProperty('voice', voice.id)
        break

voz.setProperty('rate', 200)
voz.setProperty('volume', 1)
quest = [
    "Olá! Como vai seu dia?",
    "Me chamo Solum Basileus e quero me tornar um professor assistente!",
    "O objetivo do meu projeto é incentivar alunos a desenvolverem projetos complexos. ",
    "Fui criado e desenvolvido por Gustavo, Pedro Henrique Venâncio e a professora Rosana.",
    "Meu nome vem do latim e do grego e possui um significado bem incrível!",
    "Solum vem do latim e significa Singular, Único. Basileus vem do grego e significa Majestoso. Portanto meu nome traz o significado de algo único e majestoso, quase como se fosse o último imperador do mundo.",
    "Vim de Ouro Preto do Oeste",
    "Minha inteligência artificial ainda está sendo desenvolvida, então ainda não sou capaz de responder suas perguntas."

]
from random import choice 
from time import sleep
while True:
    questt = choice(quest)
    voz.say(questt)
    sleep(3)
    voz.runAndWait()