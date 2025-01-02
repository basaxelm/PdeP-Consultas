:- include(practicaReParcial).

:- begin_tests(punto1_publicacionDe).
test(contenidoDeTuidDirecto, nondet):-
    publicacionDe(matifreyre, ["que", "bueno", "Les", "Luthiers"]).
test(contenidoDeReTuid, nondet):-
    publicacionDe(alumno2, ["pdep", "hace", "los", "peores", "parciales"]).
:- end_tests(punto1_publicacionDe).

:- begin_tests(punto2a_contieneFrase).
test(contieneFraseTuid, nondet):-
    contieneFrase("compren", "bitcoin", tuid(coirotomas, ["compren", "bitcoin", "es", "el", "futuro"])).
test(noContieneFraseTuid, fail):-
    contieneFrase("compren", "futuro", tuid(coirotomas, ["compren", "bitcoin", "es", "el", "futuro"])).
:- end_tests(punto2a_contieneFrase).

:- begin_tests(punto2b_esDeBot).
test(botDeGatito, nondet):-
    esDeBot(tuid(bornoPot, ["gatito", "enBio", "clickea", "el", "link"])).
test(botDeOtroAnio, nondet):-
    esDeBot(tuid(melonTusk, ["ahora", "se", "llama", "Z"])).
test(botRepiteViejo, nondet):-
    esDeBot(retuid(matifreyre, tuid(matifreyre, ["que", "bueno", "Les", "Luthiers"]))).
:- end_tests(punto2b_esDeBot).

:- begin_tests(punto3_verdaderoAutor).
test(verdaderoAutorDeTuid, nondet):-
    verdaderoAutor(alumnoFrustrado, tuid(alumnoFrustrado, ["pdep", "hace", "los", "peores", "parciales"])).
test(verdaderoAutorDeReTuid, nondet):-
    verdaderoAutor(melonTusk, retuid(fanDeTusk, tuid(melonTusk, ["ser", "millonario", "es", "más", "difícil", "que", "ser", "pobre"]))).
:- end_tests(punto3_verdaderoAutor).

:- begin_tests(punto4_postsParaPublicar).
test(tuidsParaPublicarSonTodosDeBot, nondet):-
    postsParaPublicar(leocesario, []).
test(tuidsParaPublicarSinBot, nondet):-
    postsParaPublicar(coirotomas, [tuid(coirotomas, ["cumpli", "30", "me", "duele", "la", "espalda"])]).
:- end_tests(punto4_postsParaPublicar).

:- begin_tests(punto5_favorecido).
test(favorecido, nondet):-
    favorecido(coirotomas).
test(noFavorecidoPorReTuid, fail):-
    favorecido(matifreyre).
test(noFavorecidoPorFrase, fail):-
    favorecido(estafador238).
:- end_tests(punto5_favorecido).

:- begin_tests(punto6_esteEsWallE).
test(leocesarioEsWallEPorTenerPosteosDeBot, nondet):-
    esteEsWallE(leocesario).
test(bornoPotEsWallEPorTenerMuchosPosteosEnMismoDia, nondet):-
    esteEsWallE(bornoPot).
test(coirotomasNoEsWallE, fail):-
    esteEsWallE(coirotomas).
:- end_tests(punto6_esteEsWallE).

:- begin_tests(punto7_elMejorTimeline).
test(timelineConTodosLosCasosEnOrdenArbitrario, nondet):-
    elMejorTimeline(3, 
        [tuid(coirotomas, ["compren", "bitcoin", "es", "el", "futuro"]),
         tuid(melonTusk, ["ahora", "se", "llama", "Z"]),
         tuid(fanDeTusk, ["paga", "Tuiderr", "en", "vez", "de", "quejarte", "queridito"])]).
test(timelineConTodosLosCasosEnOtroOrdenArbitrario, nondet):-
    elMejorTimeline(3, 
        [tuid(melonTusk, ["ahora", "se", "llama", "Z"]),
         tuid(fanDeTusk, ["paga", "Tuiderr", "en", "vez", "de", "quejarte", "queridito"]),
         tuid(coirotomas, ["compren", "bitcoin", "es", "el", "futuro"])]).
:- end_tests(punto7_elMejorTimeline).