# Scripts Python - Robô Solum

Esta pasta contém scripts Python usados anteriormente no projeto Robô Solum, para processamento de dados, geração de arquivos CSV e outras tarefas auxiliares. Atualmente, os scripts **não estão em uso ativo**, mas são mantidos para referência ou uso futuro.

## Estrutura da pasta
PYTHON/
├── SCRIPTS/ # Scripts Python principais
├── DATA/ # Arquivos CSV ou dados utilizados pelos scripts
├── libs/ # Bibliotecas utilizadas pelos scripts
└── README.md # Este arquivo


### SCRIPTS/
- Contém os scripts do projeto.
- Exemplos:
  - `gru.py` → Cria o modelo totalmente do zero e treina ele.
  - `main.py` → Aprimora o código do arquivo `gru.py`.
  - `solum.py` → Utiliza outro método de interação. O algoritmo retorna respostas com base em pergunta pré-definidas no arquivo csv.
  - `voz.py` → Cria o arquivo para transformar texto em áudio. Foi utilizado como teste inicialj dessa nova funcionalidade adicionada aos modelos

### DATA/
- Contém arquivos CSV ou outros dados necessários para os scripts.

### libs/
- Lista bibliotecas internas e externas usadas pelos scripts.
- Atualmente, serve apenas para referência (não contém arquivos `.py` adicionais).
- Exemplo de bibliotecas externas usadas:
  - pandas
  - numpy
  - matplotlib

## Observações importantes
- Os scripts **não estão em uso ativo** no projeto atual.
- Para rodar algum script futuramente:
```bash
python3 scripts/nome_do_script.py
