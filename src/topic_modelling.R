manifesto <- cleaned_manifesto_usa_duplicated1

library(stm)
processed <- textProcessor(manifesto$text_cleaned,
                           metadata=manifesto)
out <- prepDocuments(processed$documents,
                     processed$vocab,
                     processed$meta)
docs<-out$documents
vocab<-out$vocab
meta<-out$meta

First_STM <-stm(documents=out$documents, vocab=out$vocab, 
                K=22, prevalence= ~partyabbrev, max.em.its = 75, data = out$meta,
                init.type ="Spectral", verbose =FALSE)
plot(First_STM)

findThoughts(First_STM, texts=manifesto$text_cleaned, n=1, topics=4)
#working with metadata
predict_topics<-estimateEffect(formula = 1:22 ~
                                 partyabbrev,
                               stmobj = First_STM,
                               metadata = out$meta,
                               uncertainty = "Global")

plot(predict_topics, covariate="partyabbrev",
     topics =c(11, 14, 17), model =First_STM,
     method = "difference",
     cov.value1="Republicans", cov.value2 = "Democrats",
     xlab="Dem vs. Rep",
     main="Democrats ... Republicans",
     xlim= c(0,0), labeltype="custom",
     custom.labels = c('Topic 11: Iraq & Security  ','Topic 14: Government program spending', "'Topic 17: Military & Veterans ',"))