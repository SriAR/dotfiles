helper() {
    mkdir -p "logs/$1/$2"
    mv "logs/*.log" "logs/$1/$2"
    mkdir -p "pickles/$1/$2"
    mv "pickles/timeline.pkl" "pickles/$1/$2"
    mkdir -p "plots/$1/$2"
    mv "timeline.pdf" "plots/$1/$2"
}
