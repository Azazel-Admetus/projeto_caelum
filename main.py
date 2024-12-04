# importando as bibliotecas 
import pandas as pd
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
import numpy as np
# carregando o arquivo e fazendo sua leitura
arquivo = "dados.csv"
dados = pd.read_csv(arquivo)

# separando os dados por colunas
perguntas = dados['pergunta']
respostas = dados['resposta']

# tokenizar os dados
tokenizando = Tokenizer(num_words=1000)
tokenizando.fit_on_texts(perguntas + respostas)
perguntassequencia = tokenizando.texts_to_sequences(perguntas)
respostassequencia = tokenizando.texts_to_sequences(respostas)

# definindo um máximo de sequencias
max_len = max(len(seq) for seq in perguntassequencia + respostassequencia)

pergunta_pad = pad_sequences(perguntassequencia, maxlen=max_len, padding='post')
resposta_pad = pad_sequences(respostassequencia, maxlen=max_len, padding='post')

# preparando os dados para o treinamento
x = []
y = []
for seq in respostassequencia:
    for i in range(1, len(seq)):
        x.append(seq[:i])
        y.append(seq[i])

x = pad_sequences(x, maxlen=max_len, padding='post')
y = np.array(y)


# criando o modelo 
# começamos importando as bibliotecas
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Embedding, LSTM, Dense, Dropout
from time import sleep
# definindo os parâmetros
vocab_sizes = len(tokenizando.word_index) + 1
embedding_dim = 64
units = 128

modelo = Sequential([
    Embedding(input_dim=vocab_sizes, output_dim=embedding_dim, input_length=x.shape[1]),
    LSTM(units, return_sequences=True),
    Dropout(0.2),
    LSTM(units),
    Dense(64, activation='relu'),
    Dense(vocab_sizes, activation='softmax')

])
# compilando um modelo

modelo.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
def treinamento(): 
    modelo.fit(x, y, epochs=50, batch_size=32)
    modelo.summary()

# fazendo perguntas ao modelo 
def beam_search(pergunta, beam_width=3, max_len=30):
    perguntarsequencia = tokenizando.texts_to_sequences([pergunta])
    perguntarpad = pad_sequences(perguntarsequencia, maxlen=x.shape[1], padding='post')
    sequences = [[list(), 1.0]]
    
    for _ in range(max_len):
        all_candidates = list()
        for seq, score in sequences:
            # Aqui, pegamos a previsão completa (vetor de probabilidade)
            predicao = modelo.predict(perguntarpad, verbose=0)  # predicao tem forma (1, max_len, vocab_size)
            predicao = predicao[0, len(seq)]  # Pegamos a probabilidade do próximo token, baseado no comprimento atual da sequência
            
            # Obtemos os top indices com maior probabilidade
            top_indices = np.argsort(predicao)[-beam_width:]  # Pegando os top 'beam_width' índices mais prováveis
            
            for index in top_indices:
                # Criando o candidato com a sequência atual + o próximo token
                candidate = [seq + [index], score * predicao[index]]
                all_candidates.append(candidate)
        
        # Ordenando os candidatos pela probabilidade (em ordem decrescente)
        ordered = sorted(all_candidates, key=lambda tup: tup[1], reverse=True)
        sequences = ordered[:beam_width]
        
        # Se encontrarmos a palavra de fim de sequência (0), interrompemos
        if any([seq[-1] == 0 for seq, _ in sequences]):
            break

    # Pegando a sequência final
    final_sequence = sequences[0][0]
    
    # Convertendo os índices de volta para as palavras
    resposta = [tokenizando.index_word.get(token, "") for token in final_sequence]
    return " ".join(resposta)


def fazerpergunta():
    while True:
        perguntar = input("Você: ")
        if perguntar.lower() == 'sair':
            print("Encerrando...")
            sleep(2000)
            break
        respostatexto = beam_search(perguntar, beam_width=3, max_len=30)
        print("Solum: ", respostatexto if respostatexto else "Desculpa, eu não entendi a sua pergunta")

treinamento()