# CRIANDO MODELO USANDO GRU 
# PRIMEIRA ETAPA: PREPARAÇÃO DE DADOS 
# importando bibliotecas
import pandas as pd 
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
import numpy as np 
# carregando e lendo o dataset
arquivo = "dados.csv"
dados = pd.read_csv(arquivo)
# separando as perguntas e respostas 
perguntas = dados['pergunta']
respostas = dados['resposta']
# tokenizando os dados, isto é, transformando letras em números
tokenizando = Tokenizer(num_words=8000) #adiciona um parâmetro de limite de 5000 palavras mais frequentes 
tokenizando.fit_on_texts(perguntas + respostas) #atribuindo indices a cada senteça 
# transformando texto em sequência de números
perguntas_sequencia = tokenizando.texts_to_sequences(perguntas) 
respostas_sequencia = tokenizando.texts_to_sequences(respostas)
# definindo o tamanho máximo das sequencias para que todas as sequencia sejam padronizadas pela pad seuqences 
max_len = max(len(seq) for seq in perguntas_sequencia + respostas_sequencia)
# padronizando as sequencias para que elas tenham o mesmo tamanho
perguntar_pad = pad_sequences(perguntas_sequencia, maxlen=max_len, padding='post')
resposta_pad = pad_sequences (respostas_sequencia, maxlen=max_len, padding='post')
# preparando x e y como entrada e saída de dados, sendo y a sequencia de x
x = []
y = []
for seq in respostas_sequencia: #para cada sequencia 
    for i in range(1, len(seq)): #criamos pares de resposta
        x.append(seq[:i]) #esse vem primeiro e o outro vem em sequencia
        y.append(seq[i]) #assim você tem uma previsão sequencial

x = pad_sequences(x, maxlen=max_len, padding='post')
y = np.array(y)
print(x.shape)
print(y.shape)


# construindo o modelo usando gru
from tensorflow.keras.models import Sequential #usada para construir um modelo de rede neural com uma sequencia de camadas
from tensorflow.keras.layers import Embedding, GRU, Dense, Dropout #embedding=palavras->vetores, gru->relação entre palavras, denses->transforma os textos em vetores de probabilidade para gerar saída, dropout-> evita o overfitting
# Importando as bibliotecas necessárias
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Embedding, GRU, Dense, Dropout

# Definindo o modelo
modelo = Sequential()#isso define que cada camada é uma sequencia da anterior 
modelo.add(Embedding(input_dim=8000, output_dim=128, input_length=max_len)) #aqui transformamos os indices em vetores
modelo.add(GRU(units=128, return_sequences=True))#fazemos a análise desses vetores usando as células do modelo 
modelo.add(Dropout(0.2)) # desligamos 20% dos neurônios para evitar que ele aprenda as palavras sem generalizar
modelo.add(Dense(8000, activation='softmax')) #aqui transformamos os indices em vetores com probabilidades 
modelo.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy']) #aqui usamos um otimizador e função para calcular a perda de dados do aprendizado do momento e uma função para calcular a precisão do aprendizado do treinamento
modelo.summary()#isso mostra a arquitetura do modelo 
# vamos ao treinamento
def treinamento():
    modelo.fit(x, y, epochs=10, batch_size=32, validation_split=0.2 )



