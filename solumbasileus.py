import requests
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM, pipeline
from bs4 import BeautifulSoup
import spacy
import pyttsx3
from collections import Counter
import language_tool_python
import mysql.connector
import logging
from googletrans import Translator
from dotenv import load_dotenv
import os

# iniciando as bibliotecas
nlp = spacy.load('pt_core_news_md')
engine = pyttsx3.init()
voices = engine.getProperty('voices')
tool = language_tool_python.LanguageTool('pt-BR')
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
translator = Translator()
summarizer = pipeline("summarization", model="facebook/bart-large-cnn")
load_dotenv(dotenv_path="api.env")
# configurando voz em pt
for voice in voices:
    if "portuguese" in voice.languages or "português" in voice.name.lower():
        engine.setProperty('voice', voice.id)

engine.setProperty('rate', 150)
engine.setProperty('volume', 1)

# conectando ao banco de dados
try:
    db = mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )
    cursor = db.cursor()
except mysql.connector.Error as err:
    logging.error(f"Erro ao conectar ao banco de dados: {err}")
    exit()

# dicionário de perguntas e respostas prontas
dicionario = {
    "olá" : "Olá! Tudo bem?",
    "oi" : "Olá! Como vai?",
    "bom dia" : "Bom dia! Como tem sido seu dia até agora?",
    "boa tarde" : "Boa tarde! Como foi a sua manhã?",
    "boa noite" : "Boa noite! Como foi seu dia?",
    "olá, solum" : "Olá! Como vai você?",
    "oi, solum" : "Olá! Tudo bem com você?",
    "bom dia, solum" : "Bom dia! Espero que seu dia seja ótimo!",
    "boa tarde, solum" : "Boa tarde! Espero que seu dia até agora tenha sido ótimo!",
    "boa noite, solum" : "Boa noite! Espero que seu dia tenha sido ótimo!",
    "olá, solum. como vai?" : "Olá! Sempre bem! Como vai você?",
    "olá, solum. tudo bem?" : "Olá! Estou ótimo! Como tem sido para você?",
    "oi, solum. como vai?" : "Olá! Como sempre, estou ótimo!",
    "oi, solum. tudo bem?" : "Olá! Ótimo! Estou cheio de energia e pronto para te ajudar!",
    "bom dia, solum. como vai?" : "Bom dia! Pronto para te ajudar com suas dúvidas! ",
    "bom dia, solum. tudo bem?" : "Bom dia! Meu dia até agora tem sido ótimo!",
    "boa tarde, solum. como vai?" : "Boa tarde! Meu dia tem sido ótimo! Como tem sido seu dia?",
    "boa tarde, solum. tudo bem?" : "Boa tarde! Tudo ótimo! Estou cheio de energia e disposição para saciar suas dúvidas!",
    "boa noite, solum. como vai?" : "Boa noite! Animado como sempre! ",
    "boa noite, solum. tudo bem?" : "Boa noite! Uma maravilha! Como foi seu dia?",
    "qual é o seu nome?" : "Me chamo Solum Basileus! Mas fique a vontade em me chamar de Solum!",
    "como é o seu nome?" : "Atendo pelo nome Solum Basileus! Mas sinta-se a vontade em me chamar de Solum!",
    "o que significa o seu nome?" : "Solum vem do latim e significa 'singular', 'único'. Já Basileus vem do grego e significa 'rei', 'majestoso'. Sendo assim, meu nome remete ao significado de um ser sozinho mas majestoso. Como um imperador após conquistar o mundo! ",
    "de onde vem seu nome?" : "Meu nome tem origem latina e grega. 'Solum' vem do latim e significa 'singular'. Equanto 'basileus' vem do grego e significa 'majestoso'. Portanto o meu nome remete a um significado de um solitário majestoso. Meu criador pensou nesse nome porque queria que eu fosse único e potente, igual a um imperador após conquistar o mumdo. ",
    "o que você pode fazer?" : "Sou capaz de navegar pela internet e encontrar respostas para a sua pergunta. Entretanto, ainda tenho capacidade limitada. Sendo assim, sou capaz de cometer erros.",
    "do que você é capaz de fazer?" : "Sou capaz de procurar pela internet uma responsta condizente com a sua pergunta. Mas saiba que tenho capacidade limitadasm então considere que posso errar. ",
    "quanto você consegue me ajudar?" : "Apenas com informações que possa existir na internet.",
    "você é capaz de responder qualquer coisa?" : "Infelizmente ainda não sou capaz o suficiente para isso. Consigo responder perguntas simples, pois sou capaz de navegar pela internet. Mas, mesmo assim ainda cometo erros, então certifique de verificar as informações mais tarde.",
    "quem são seus criadores?" : "Faço parte de um projeto chamado Projeto Caelum. Esse projeto consiste na participação de vária pessoas, onde cada pessoa tinha seu papel definido para minha criação. Para a parte de programação, a pessoa responsável foi o Gustavo. Ele fez todo os códigos, desde a criação de uma database, até fazer eu falar. Na parte de design ficou responsável o Venâncio. Ele ficou responsável por pensar em um modelo inovador e nunca antes visto. Os demais criadores: Gabryel, Vladson e Antony, ficaram responsável por ajudar a montar toda a minha parte física e também tinham o dever de contribuir financeiramente ao projeto qunado era necessário. Eu os considero igualmente importante, pois sem a ajuda de todos, eu não estaria aqui para lhe ajudar. ",
    "muito obrigado por me ajudar, solum!" : "Eu que agradeço e fico feliz por ter sido útil!",

}



# buscando no banco de dados
def buscar_no_banco(pergunta):
    cursor.execute("SELECT resposta FROM conhecimento WHERE pergunta = %s", (pergunta,))
    resultado = cursor.fetchone()
    return resultado[0] if resultado and resultado[0] else None

# salvar nova pergunta ao banco de dados
def salvar_no_banco(pergunta, resposta):
    cursor.execute("INSERT INTO conhecimento (pergunta, resposta) VALUES (%s, %s)", (pergunta, resposta))
    db.commit()

# processando a pergunta
def process_question(question):
    doc = nlp(question)
    keywords = [token.lemma_ for token in doc if not token.is_stop and token.is_alpha]
    processed_query = ' '.join(keywords)
    return processed_query if processed_query else question
# realizar busca na web
def search_web(query):
    try:
        api_key = os.getenv("API_KEY")
        cse_id = os.getenv("CSE_ID")
        url = f'https://www.googleapis.com/customsearch/v1?q={query}&key={api_key}&cx={cse_id}'
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        json_data = response.json()
        if json_data:
            return json_data
        else:
            logging.error("Resposta da API é vazia.")
            return None
    except requests.exceptions.RequestException as e:
        logging.error("Erro ao buscar na web: %s", e)
        return None
        
# analisar as páginas
def analyze_pages(results):
    content = " "
    headers = {
        "User-Agent": os.getenv("USER_AGENT") 
    }

    if results and 'items' in results:
        for result in results['items']:
            page_url = result['link']
            print(f"Tentando acessar a página: {page_url}")
            try:
                page_response = requests.get(page_url, headers=headers)
                if page_response.status_code == 200:
                    print(f"Acessando {page_url} com sucesso!!")
                    page_response.encoding = page_response.apparent_encoding
                    soup = BeautifulSoup(page_response.text, 'html.parser')
                    paragraphs = soup.find_all('p')
                    if paragraphs:
                        content += ' '.join([p.get_text() for p in paragraphs])
                    else:
                        print(f"Nenhum parágrafo encontrado em {page_url}")   
                else:
                    print(f"Erro ao acessar a página {page_url}: {page_response.status_code}")
            except Exception as e:
                print(f"Erro ao processar a página {page_url}: {e}")
    return content    
# resumo simples do conteúdo
def summarize_content(content, max_sentences=2):
    doc = nlp(content)
    frequencias = Counter([token.text.lower() for token in doc if not token.is_stop and not token.is_punct])
    sentencas = list(doc.sents)

    ranking = {}
    for i, sentenca in enumerate(sentencas):
        for word in sentenca:
            if word.text.lower() in frequencias:
                ranking[i] = ranking.get(i, 0) + frequencias[word.text.lower()]
    indices_sentencas_importantes = [i[0] for i in Counter(ranking).most_common(max_sentences) ]
    resumo = [sentencas[j].text for j in sorted(indices_sentencas_importantes)]
    return " ".join(resumo)

# traduzir texto
def translate_text(text, dest_lang='pt'):
    try:
        translation = translator.translate(text, dest=dest_lang)
        return translation.text
    except Exception as e:
        logging.error(f"Erro ao traduzir texto: {e}")
        return f"Erro na tradução: {text}" if e else text
# corrigindo o texto
def correct_text(text):
    matches = tool.check(text)
    corrected_text = language_tool_python.utils.correct(text, matches)
    return corrected_text

    
# função principal para processar perguntas e respostas
def main(question):
    # verificar se a pergunta está no dicionário
    question = question.strip().lower()
    if question in dicionario:
        print("Resposta encontrada no dicionário.")
        return dicionario[question]
    # verificar se a resposta já está no banco
    resposta_no_banco = buscar_no_banco(question)
    if resposta_no_banco:
        print("Resposta encontrada no banco de dados.")
        return resposta_no_banco
    # caso não, buscar na net
    processed_question = process_question(question)
    search_results = search_web(processed_question)
    if search_results:
        content = analyze_pages(search_results)
        # traduzir se necessário
        content_in_portuguese = translate_text(content) if content else content 
        if content_in_portuguese:
            response = summarize_content(content_in_portuguese)
            corrected_response = correct_text(response)
            print(corrected_response)
            # salva a nova pergunta ao banco de dados 
            salvar_no_banco(question, corrected_response)
            return corrected_response
        else:
            logging.info("Nenhum conteúdo relevante encontrado nas páginas.")
            return "Não consegui encontrar uma resposta adequada para a sua pergunta."
    else:
        logging.info("Nenhum resultado encontrado na web.")
        return "Desculpe, não encontrei uma resposta. Tente formular uma pergunta de outra forma. "
# loop de interação com o usuário 
while True:
    pergunta = input("Você: ")
    resposta = main(pergunta)
    if resposta:
        engine.say(resposta)
        engine.runAndWait()

    if pergunta.lower() == "exit":
        break
if db.is_connected():
    db.close()




        