//Run a completion on the UI thread.
func onui<T>(completion:(T -> ())) -> (T->()){
    return { t in dispatch_async(dispatch_get_main_queue(), { completion(t) }) }
}
