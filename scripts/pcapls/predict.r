library("pls")

allf0data = read.table('all_transformed.f0', header=TRUE);
# in these files we go tone1..tone5 spk1..8 s1..s30
zerorows = apply(allf0data[14:43], 1, min)==0; # indices depend on data file
f0data = allf0data[!zerorows,]

correct = 0
correct_fp = 0
incorrect_fp = 0
incorrect_nothing= 0

eps = 1.0

truetone = FALSE
falsepos = 0


# use a leave-one-out method: train on all but one sample
numsamples = nrow(f0data)

cat(sprintf("running on %d samples\n", numsamples, eps))

for (i in 1:numsamples) {

    truetone = FALSE
    falsepos = 0
    falseneg = FALSE

    test = f0data[i,]
    train = f0data[c(seq_len(i-1), seq_len(numsamples-i)+i),] # all others
    # train a model
    dataframe = data.frame(tones=I(as.matrix(train[,1:5])), obs=I(as.matrix(train[,6:43])))
    cat(sprintf("training model...\n"))
    model = plsr(tones~obs, data=dataframe, validation="LOO")
    cat(sprintf("trained model...\n"))
    # use the model to predict
    new = predict(model, ncomp=model$ncomp, newdata=as.matrix(test[6:43])) # use same number of components as the cross-validated model
#    new = predict(model, ncomp=3, newdata=as.matrix(test[6:43])) # use a small number of components
    # test the result
    closest_t1 = floor(new[[1]]+0.5) # round it to an integer
    closest_t2 = floor(new[[2]]+0.5) # round it to an integer
    closest_t3 = floor(new[[3]]+0.5) # round it to an integer
    closest_t4 = floor(new[[4]]+0.5) # round it to an integer
    closest_t5 = floor(new[[5]]+0.5) # round it to an integer

    if (closest_t1 >= 1) { # to allow for things getting rounded up to 2, or something
        if (test[[1]] == 1) {
            truetone = TRUE # true positive
        }
        else {
            falsepos = falsepos + 1 # false positive
        }
    }
    else {
        if (test[[1]] == 1) { # false negative
            falseneg = TRUE
        }
    }
    
    if (closest_t2 >= 1) {
        if (test[[2]] == 1) {
            truetone = TRUE # true positive
        }
        else {
            falsepos = falsepos + 1 # false positive
        }
    }
    else {
        if (test[[2]] == 1) { # false negative
            falseneg = TRUE
        }
    }
    
    if (closest_t3 >= 1) {
        if (test[[3]] == 1) {
            truetone = TRUE # true positive
        }
        else {
            falsepos = falsepos + 1 # false positive
        }
    }
    else {
        if (test[[3]] == 1) { # false negative
            falseneg = TRUE
        }
    }
    
    if (closest_t4 >= 1) {
        if (test[[4]] == 1) {
            truetone = TRUE # true positive
        }
        else {
            falsepos = falsepos + 1 # false positive
        }
    }
    else {
        if (test[[4]] == 1) { # false negative
            falseneg = TRUE
        }
    }
    
    if (closest_t5 >= 1) {
        if (test[[5]] == 1) {
            truetone = TRUE # true positive
        }
        else {
            falsepos = falsepos + 1 # false positive
        }
    }
    else {
        if (test[[5]] == 1) { # false negative
            falseneg = TRUE
        }
    }

    if (truetone == TRUE && falsepos == 0) { # correct tone, no others selected
        cat(sprintf("sample %d correct\n", i))
        correct = correct + 1
    }
    if (truetone == TRUE && falsepos > 0) { #correct tone, but others selected
        cat(sprintf("sample %d correct with %d false positives\n", i, falsepos))
        correct_fp = correct_fp + 1
    }
    if (truetone == FALSE && falsepos > 0) { # correct tone not selected, others selected
        cat(sprintf("sample %d tone not detected, %d false positives\n", i, falsepos))
        incorrect_fp = incorrect_fp + 1
    }
    if (truetone == FALSE && falsepos == 0) { # nothing detected
        cat(sprintf("sample %d no tones detected", i))
        incorrect_nothing = incorrect_nothing + 1
    }
    
    

}

print("Samples: ")
print(numsamples)

print("Correct (no extra selections): ")
print(correct)

print("Correct tone selected, with extra selections: ")
print(correct_fp)

print("Incorrect tones selected: ")
print(incorrect_fp)

print("Nothing selected: ")
print(incorrect_nothing)
