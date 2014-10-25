# Example code for generating models, plots, confusion matrices shown in the results
# See also Haejoong Lee https://code.google.com/p/prosody/source/browse/fpca/fda_hw2/data/process.R
# Requires mixOmics library

library('mixOmics')

# section 5.3
synth = read.table('synthetic_data.f0', header=TRUE)
synth.model = plsda(synth[,c(1,2,4:33)], synth$tone, ncomp=5)
synth.error = valid(synth.model, validation="LOO")
col.synth = as.numeric(as.factor(synth$tone))
col.synth[col.synth == 1] <- 'red'
col.synth[col.synth == 2] <- 'blue'
plot(synth.error[,1], type="l", col="red", xlab="number of components", ylab="error rate (LOO)", main="Synthetic data error rates (LOO validation)")
plot(synth.error[,1], type="l", col="red", xlab="number of components", ylab="error rate", main="Synthetic data error rates (LOO validation)")
plotIndiv(synth.model, comp = 1:2, ind.names = FALSE, col = col.synth, cex = 1, pch = 16, main="Synthetic data projection")
legend("topright", c("tone 1", "tone 2"), pch=16, col=c('red','blue'))

# 5.4
f0data = read.table('all.f0', header=TRUE)
zerorows = apply(f0data[12:41], 1, min)==0
f0data1 = f0data[!zerorows,12:41]
f0inds1 = f0data[!zerorows,1:10]
X <- f0data1
Y <- as.factor(f0inds1$tone)
col.f0data1 = as.numeric(as.factor(f0inds1$tone))
col.f0data1
col.f0data1[col.f0data1 == 1] <- 'red'
col.f0data1[col.f0data1 == 2] <- 'blue'
col.f0data1[col.f0data1 == 3] <- 'black'
col.f0data1[col.f0data1 == 4] <- 'green'
col.f0data1[col.f0data1 == 5] <- 'purple'
result.pls = splsda(X, Y, ncomp=3)
plot3dIndiv(result.pls, comp = 1:3, col = col.f0data1, cex = 0.04, axes.box = "both")

#5.4 reduced

f0data1_1s <- f0data1[f0inds1$tone==1,]
f0data1_2s <- f0data1[f0inds1$tone==2,]
f0data1_3s <- f0data1[f0inds1$tone==3,]
f0data1_4s <- f0data1[f0inds1$tone==4,]
f0inds1_1s <- f0inds1[f0inds1$tone==1,]
f0inds1_2s <- f0inds1[f0inds1$tone==2,]
f0inds1_3s <- f0inds1[f0inds1$tone==3,]
f0inds1_4s <- f0inds1[f0inds1$tone==4,]
samp1 <- sample(nrow(f0data1_1s), 250)
samp2 <- sample(nrow(f0data1_2s), 250)
samp3 <- sample(nrow(f0data1_3s), 250)
samp4 <- sample(nrow(f0data1_4s), 250)
f0data1_sampled <- rbind(f0data1_1s[samp1,], f0data1_2s[samp2,], f0data1_3s[samp3,], f0data1_4s[samp4,])
f0inds1_sampled <- rbind(f0inds1_1s[samp1,], f0inds1_2s[samp2,], f0inds1_3s[samp3,], f0inds1_4s[samp4,])
result.sampled <- splsda(f0data1_sampled, f0inds1_sampled$tone, ncomp=5)
error.sampled.loo <- valid(result.sampled, validation="LOO")
plot(error.sampled.loo[,1], type="l", xlab="number of components", ylab="error rate", col="red", ylim=c(0,.65), main="Mandarin subset error rates (LOO validation)")

pred.sampled <- predict(result.sampled, f0data1_sampled)
conf.sampled <- matrix(0,4,4)
for (i in 1:nrow(f0data1_sampled)){
	thispred <- pred.sampled$class$max.dist[i,][3]
	thisreal <- f0inds1_sampled$tone[i]
	conf.sampled[thisreal,thispred] <- conf.sampled[thisreal,thispred] + 1
}

# 5.5 for LOO error graph

# setting up data

f0_midbreaks = f0data[zerorows & f0data$s1!=0 & f0data$s30!=0,]
f0b1 = f0_midbreaks[f0_midbreaks$tone==1,]
f0b2 = f0_midbreaks[f0_midbreaks$tone==2,]
f0b3 = f0_midbreaks[f0_midbreaks$tone==3,]
f0b4 = f0_midbreaks[f0_midbreaks$tone==4,]
sf0b1 <- sample(nrow(f0b1), 40)
sf0b2 <- sample(nrow(f0b2), 40)
sf0b3 <- sample(nrow(f0b3), 40)
sf0b4 <- sample(nrow(f0b4), 40)
f0_midbreaks_f0 = f0_midbreaks[,12:41]
f0_midbreaks_inds = f0_midbreaks[,1:10]
f0_midbreaks_f0_1s <- f0_midbreaks[f0_midbreaks$tone==1, 12:41]
f0_midbreaks_f0_2s <- f0_midbreaks[f0_midbreaks$tone==2, 12:41]
f0_midbreaks_f0_3s <- f0_midbreaks[f0_midbreaks$tone==3, 12:41]
f0_midbreaks_f0_4s <- f0_midbreaks[f0_midbreaks$tone==4, 12:41]
f0_midbreaks_inds_1s <- f0_midbreaks[f0_midbreaks$tone==1, 1:10]
f0_midbreaks_inds_2s <- f0_midbreaks[f0_midbreaks$tone==2, 1:10]
f0_midbreaks_inds_3s <- f0_midbreaks[f0_midbreaks$tone==3, 1:10]
f0_midbreaks_inds_4s <- f0_midbreaks[f0_midbreaks$tone==4, 1:10]


sf0v1 <- sample(nrow(f0data1_1s), 210)
sf0v2 <- sample(nrow(f0data1_2s), 210)
sf0v3 <- sample(nrow(f0data1_3s), 210)
sf0v4 <- sample(nrow(f0data1_4s), 210)
f0data_b_sampled <- rbind(f0data1_1s[sf0v1,], f0_midbreaks_f0_1s[sf0b1,], f0data1_2s[sf0v2,], f0_midbreaks_f0_2s[sf0b2,], f0data1_3s[sf0v3,], f0_midbreaks_f0_3s[sf0b3,], 
f0data1_4s[sf0v4,], f0_midbreaks_f0_4s[sf0b4,])
f0inds_b_sampled <- rbind(f0inds1_1s[sf0v1,], f0_midbreaks_inds_1s[sf0b1,], f0inds1_2s[sf0v2,], f0_midbreaks_inds_2s[sf0b2,], f0inds1_3s[sf0v3,], f0_midbreaks_inds_3s[sf0b3,], 
f0inds1_4s[sf0v4,], f0_midbreaks_inds_4s[sf0b4,])

f0data_b_sampled_interp <- read.table("interpolated.f0", header=TRUE)
f0data_b_sampled_smoothed <- read.table("allsmoothed.f0", header=TRUE)
f0data_b_sampled_NAs <- f0data_b_sampled
f0data_b_sampled_NAs[f0data_b_sampled_NAs==0] <- NA
NAs.model <- plsda(f0data_b_sampled_NAs, f0inds_b_sampled$tone, ncomp=3)
f0data_b_sampled_interponly <- read.table("interponly.f0", header=TRUE)

# graphs

interp.model <- plsda(f0data_b_sampled_interp, f0inds_b_sampled$tone, ncomp=5)
interp.error <- valid(interp.model, validation="LOO")
allsmoothed.model <- plsda(f0data_b_sampled_smoothed, f0inds_b_sampled$tone, ncomp=5)
allsmoothed.error <- valid(allsmoothed.model, validation="LOO")
interponly.model <- plsda(f0data_b_sampled_interponly, f0inds_b_sampled$tone, ncomp=5)
interponly.error <- valid(interponly.model, validation="LOO")

# matrices

f0btest_1s <- f0data1_1s[-sf0v1,][sample(nrow(f0data1_1s[-sf0v1,]), 75),]
f0btest_2s <- f0data1_2s[-sf0v2,][sample(nrow(f0data1_2s[-sf0v2,]), 75),]
f0btest_3s <- f0data1_3s[-sf0v3,][sample(nrow(f0data1_3s[-sf0v3,]), 75),]
f0btest_4s <- f0data1_4s[-sf0v4,][sample(nrow(f0data1_4s[-sf0v4,]), 75),]
f0btest <- rbind(f0btest_1s, f0btest_2s, f0btest_3s, f0btest_4s)
f0btest_f0 = f0btest

f0btest_tone = rep(c(1,2,3,4), each=75)

NAs.confmatrix.test <- matrix(0,4,4)
for (i in 1:nrow(f0btest_f0)) {
    thisreal <- f0btest_tone[i]
    thispred <- predict(NAs.model, f0btest_f0[i,])$class$max.dist[3]
    NAs.confmatrix.test[thisreal,thispred] <- NAs.confmatrix.test[thisreal,thispred]+1
}
interp.confmatrix.test <- matrix(0,4,4)
for (i in 1:nrow(f0btest_f0)) {
    thisreal <- f0btest_tone[i]
    thispred <- predict(interp.model, f0btest_f0[i,])$class$max.dist[3]
    interp.confmatrix.test[thisreal,thispred] <- interp.confmatrix.test[thisreal,thispred]+1
}
allsmoothed.confmatrix.test <- matrix(0,4,4)
for (i in 1:nrow(f0btest_f0)) {
    thisreal <- f0btest_tone[i]
    thispred <- predict(allsmoothed.model, f0btest_f0[i,])$class$max.dist[3]
    allsmoothed.confmatrix.test[thisreal,thispred] <- allsmoothed.confmatrix.test[thisreal,thispred]+1
}
interponly.confmatrix.test <- matrix(0,4,4)
for (i in 1:nrow(f0btest_f0)) {
    thisreal <- f0btest_tone[i]
    thispred <- predict(interponly.model, f0btest_f0[i,])$class$max.dist[3]
    interponly.confmatrix.test[thisreal,thispred] <- interponly.confmatrix.test[thisreal,thispred]+1
}


voicedmodel.confmatrix.test <- matrix(0,4,4)
for (i in 1:nrow(f0btest_f0)) {
    thisreal <- f0btest_tone[i]
    thispred <- predict(result.sampled, f0btest_f0[i,])$class$max.dist[3]
    voicedmodel.confmatrix.test[thisreal,thispred] <- voicedmodel.confmatrix.test[thisreal,thispred]+1
}


plot(interp.error[,1],type="l", ylim=c(0,0.70), main="Error rates for different models of interpolation (LOO validation)", col="red", xlab="number of components", ylab="error rate")
lines(allsmoothed.error[,1], col="blue")
lines(interponly.error[,1], col="darkgreen")
lines(error.sampled.loo[,1], col="black", lty=2)
legend("topright", c("interpolation and smoothing (broken contours)", "interpolation and smoothing (all contours)", "interpolation only (broken contours)", "fully voiced model (reference)"), lty=c(1,1,1,2), col=c("red", "blue", "darkgreen", "black"))


# 5.6 context

# values from my records - lost the RData file for them, can regenerate from history if needed
sb2syl__f0only.error = c(0.3944637, 0.4256055, 0.4256055, 0.4221453, 0.4290657)
sb2syl__f0context.error = c(0.3771626, 0.3148789, 0.3079585, 0.3010381, 0.2975779)
sb2syl__f0leading.error = c(0.3771626, 0.3114187, 0.3079585, 0.2975779, 0.2975779)
sb2syl__f0following.error = c(0.3944637, 0.4186851, 0.4117647, 0.3979239, 0.4048443)

plot(1:5, sb2syl__f0only.error, col="ivory4", type="l", ylim=c(0,0.43), main="Error rates using different contextual information (LOO validation)", xlab="number of components", ylab="error rate")
lines(1:5, sb2syl__f0context.error, col="blue")
lines(1:5, sb2syl__f0leading.error, col="deeppink")
lines(1:5, sb2syl__f0following.error, col="mediumseagreen")
legend("bottomright", c("no context", "both sides", "before only", "after only"), lty=1, col=c("ivory4", "blue", "deeppink", "mediumseagreen"))

# violin errors - again, errors from records
vln_rlb_res_f0 = c(.6065574, .6393443, .5901639, .6065574, .6721311)
vln_rlb_res_fstr = c(.6065574, .6393443, .5901639, .6393443, .7540984)
vln_rlb_res_fstr_pos = c(.5901639, .6229508, .6229508, .7377049, .6721311)
plot(1:5, vln_rlb_res_f0, type="l", ylim=c(0, 0.755), main="Error rates in models built from subset of violin data (LOO validation)", xlab="number of components", ylab="error rate")
lines(1:5, vln_rlb_res_fstr, col="red")
lines(1:5, vln_rlb_res_fstr_pos, col="blue")
legend("bottomright", c("F0 only", "F0 and string", "F0, string and position"), lty=1, col=c("black", "red", "blue"))

# 5.7 generated stuff (fixed)
fixgen5 = read.table("fixgen5.f0", header=TRUE)
fixgen5.model <- plsda(fixgen5[,1:30], fixgen5$tone, ncomp=12)
fixgen5.error <- valid(fixgen5.model, validation="LOO")
# from levels(fixgen5$tone)
flv5 <- list()
flv5["100q"] <- 1
flv5["cube"] <- 2
flv5["fall"] <- 3
flv5["flat"] <- 4
flv5["qua2"] <- 5
flv5["quad"] <- 6
flv5["rise"] <- 7
flv5["uqua"] <- 8
fixgen5.loo.cm <- matrix(0,8,8)
for (i in 1:nrow(fixgen5)) {
    thisrow = fixgen5[i,]
    allbut = fixgen5[-i,]
    # 5 components from error
    thismodel <- plsda(allbut[,1:30], allbut$tone, ncomp=5)
    thisreal <- as.double(flv5[thisrow$tone])
    thispred <- predict(thismodel, thisrow[1:30])$class$max.dist[5]
    fixgen5.loo.cm[thisreal,thispred] <- fixgen5.loo.cm[thisreal,thispred]+1
}

