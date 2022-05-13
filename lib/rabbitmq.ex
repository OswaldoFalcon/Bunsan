defmodule RabbitMQ.System do
  @doc """
  Creates the exchaange, the queues and their bindings.
  If the exchange and queues already exist, does nothing.
  """
  def setup(exchange_name, queue_names) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Exchange.declare(channel, exchange_name, :direct)

    Enum.map(queue_names, fn queue_name ->
      AMQP.Queue.declare(channel, queue_name)
      AMQP.Queue.bind(channel, queue_name, exchange_name, routing_key: queue_name)
    end)
  end
end

defmodule RabbitMQ.Producer do
  @doc """
  Sends n messages with payload 'msg' and the given routing key.
  """
  def send(exchange, routing_key, msg, n) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    Enum.each(1..n, fn i ->
      AMQP.Basic.publish(channel, exchange, routing_key, msg <> "number: " <> "#{i}")
    end)
  end
end

defmodule RabbitMQ.Consumer do
  require Logger

  @doc """
  Creates a process that listens for messages on the given queue.
  When a message arrives, it writes to the log the pid, queue_name and msg.
  Example:
    iex> {:ok, pid} = Consumer.start("orders")
  """
  def start(queue_name) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    pid = spawn(RabbitMQ.Consumer, :wait_for_messages, [channel])
    AMQP.Basic.consume(channel, queue_name, pid, no_ack: true)
    pid
  end

  def wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, meta} ->
        Logger.info("PID: #{inspect(self())}, Queue: #{meta.routing_key} , Msg: #{payload}")
        # IO.puts " [x] Received [#{meta.routing_key}] #{payload}"
        meta
    end

    wait_for_messages(channel)
  end

  @doc """
  Stops the given consumer.
  Example:
    iex> Consumer.stop("orders")
  """
  def stop(pid) do
    Process.exit(pid, :kill)
  end
end
