## PUTS DEV - Framework

Puts dev, ja se perguntou como seria construir um framework?

Esse repositório busca desbravar um pouco dessa ideia(junto aos videos ao final desse README).

Vamos rascunhar uma primeira ideia de construção de um framework web com ruby :D

Fonte de inspiração inicial e conhecimento:
[https://www.youtube.com/watch?v=lxczDssLYKA](https://www.youtube.com/watch?v=lxczDssLYKA)

Detalhes sobre HTTP
[https://en.wikipedia.org/wiki/HTTP](https://en.wikipedia.org/wiki/HTTP)


Doc do socket
[https://docs.ruby-lang.org/en/2.1.0/Socket.html](https://docs.ruby-lang.org/en/2.1.0/Socket.html)

## Youtube

- Parte 1
[Youtube link](https://www.youtube.com/watch?v=A0AaAnc9z3g=)

- Parte 2
[Youtube link](https://www.youtube.com/watch?v=e0nAhVyrIAM)

- Parte 3
[Youtube link](https://www.youtube.com/watch?v=-rru0sTs5CQ)

- Parte 4
[Youtube link](https://youtu.be/AGp2OPhpgIk)

# Comandos básicos:

subir servidor:
ruby ./bin/framework.rb server

criar banco:
ruby ./bin/framework.rb db create:db

apagar banco:
ruby ./bin/framework.rb db drop:db

criar migration:
ruby ./bin/framework.rb db create:migration CreateProductsTable

aplicar migrations:
ruby ./bin/framework.rb db migrate
